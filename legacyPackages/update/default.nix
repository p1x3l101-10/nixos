{ ext
, lib
, writeShellApplication
, nix-output-monitor
}:

let
  types = ext.lib.infusion.mkTypes "Automatic Updater" (yants: with yants; rec {
    commandType = either (list (either path string)) path;
    updateBlock = struct "updateBlock" {
      command = commandType;
      attrPath = option string;
      supportedFeatures = option (list string);
    };
    validUpdateTypes = either commandType updateBlock;
    updateBlockStrict = struct "updateBlockStrict" {
      command = list (either path string);
      attrPath = string;
      supportedFeatures = list string;
    };
    packageWithUpdater = openStruct "packageWithUpdater" {
      updateScript = validUpdateTypes;
    };
    packageOrSet = either (attrs any) drv;
  });
  inherit (types) defun;
  # TODO: Try to match `update.nix`
  # See more: `https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md#automatic-package-updates`
  assembleUpdater = defun (with types; [ validUpdateTypes string updateBlockStrict ]) (updateBlock: attrPath:
    (
      if (types.commandType.check updateBlock) then (
        if (builtins.isList updateBlock) then (
          {
            command = updateBlock;
            inherit attrPath;
            supportedFeatures = [];
          }
        ) else (
          {
            command = [ updateBlock "legacyPackages/${(builtins.replaceStrings [ "." ] [ "/" ] attrPath)}" ]; # Automatically pass the package path to a simple updater
            inherit attrPath;
            supportedFeatures = [];
          }
        )
      ) else (
        let
          defaultPart = partName: default: if (builtins.hasAttr partName updateBlock) then (updateBlock."${partName}") else default;
        in {
          inherit (updateBlock) command;
          attrPath = defaultPart "attrPath" attrPath;
          supportedFeatures = defaultPart "supportedFeatures" [];
        }
      )
    )
  );
  scanPackages = packageOrSet: acc: (
    if (builtins.hasAttr "packages" packageOrSet) then ( # Is a package set
      (builtins.mapAttrs
        (name: value:
          scanPackages value (acc ++ [ name ])
        )
        (builtins.removeAttrs
          packageOrSet
          [
            "callPackage"
            "newScope"
            "overrideScope"
            "packages"
          ]
        )
      )
    ) else ( # Is a package
      if (builtins.hasAttr "updateScript" packageOrSet) then ( # Supports auto updates
        {
          _type = "autoUpdate";
          updater = assembleUpdater packageOrSet.updateScript (builtins.concatStringsSep "." acc);
        }
      ) else ( # Does not support auto updates
        null
      )
    )
  );
  updateList' = packageSet: (map
    (x:
      if (builtins.isAttrs x.value) then (
        if (builtins.hasAttr "_type" x.value) then (
          if (x.value._type == "autoUpdate") then (
            x.value.updater
          ) else (updateList' x.value)
        ) else (updateList' x.value)
      ) else null
    )
    (lib.attrsToList packageSet)
  );
  updateList = (builtins.filter 
    (x: ! builtins.isNull x)
    (lib.lists.flatten
      (updateList' (scanPackages ext.inputs.self.legacyPackages."${ext.system}" []))
    )
  );
in writeShellApplication {
  name = "updater";
  runtimeInputs = [
    nix-output-monitor
  ];
  text = ''
    exec ${./updater.nu} '${builtins.toJSON updateList}' "$@"
  '';
}
