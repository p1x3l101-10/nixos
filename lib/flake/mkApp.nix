{ lib, ext, self }:

let
  types = self.infusion.mkTypes "flake.mkApp" (types:
    with types; let
      structWrapper = structType: contentFunction: x: (
        if (builtins.isString x) then (contents:
          structType x (contentFunction contents)
        ) else (
          structType (contentFunction x)
        )
      );
    in rec {
      packageBuilderStruct = structWrapper struct (content:
        (lib.mapAttrs
          (_: v: option v)
          (content // {
            meta = attrs any;
            passthru = attrs any;
          })
        )
      );
      app = struct "app" {
        type = "app";
        program = drv;
      };
      nushellModules = drv;
      nushellArgs = packageBuilderStruct "nushellArgs" {
        version = string;
        binaryPath = list drv;
        nuModules = nushellModules;
        preProcessInstallCommands = string;
        extraInstallCommands = string;
      };
      bashArgs = packageBuilderStruct "bashArgs" {
        runtimeInputs = list drv;
        runtimeEnv = attrs string;
        checkPhase = drv;
        excludeShellChecks = list str;
        extraShellCheckFlags = list str;
        bashOptions = list str;
        derivationArgs = attrs any;
        inheritPath = bool;
      };
    }
  );
  inherit (types) defun;
  filterAttrs = lib.fix (finalFilter: 
    let
      attrset = with types; attrs any;
      defun' = midType: function: defun [ attrset midType attrset ] function;
      autoFun = function: defun [ attrset attrset ] function;
    in {
    __functor = self: self.generic;
    filters = {
      rejectByType = typeFilter: ({ name, value }: !typeFilter value);
    };
    generic = defun' types.function (attrs: filterFunction:
      builtins.listToAttrs (
        builtins.filter
        filterFunction
        (lib.attrsToList attrs)
      )
    );
    # Seems silly, but still
    byName = defun' (with types; list string) (attrs: forbiddenStrings:
      builtins.removeAttrs attrs forbiddenStrings
    );
    empty = autoFun (attrs:
      finalFilter.generic attrs (finalFilter.filters.rejectByType builtins.isNull)
    );
  });
in lib.fix (final: {
  __functor = self: self.generic;
  generic = defun (with types; [ drv app ]) (drv:
    {
      type = "app";
      program = drv;
    }
  );
  nu = final.nushell;
  nushell = defun (with types; [ string nushellArgs string app ]) (name: builderArgs: content:
    let
      inherit (self.builders.nushell) mkNuScript renamePath;
    in final.generic (mkNuScript
      ((filterAttrs.empty builderArgs) // {
        inherit name;
        packageDirFilter = (_: true);
        srcScriptName = "main.nu";
        packageDir = renamePath (builtins.toFile "main.nu" ("#!/usr/bin/env nu\n" + content)) "main.nu";
      })
    )
  );
  shell = final.bash;
  script = final.bash;
  bash = defun (with types; [ string bashArgs string app ]) (name: builderArgs: content:
    final.generic ext.pkgs.writeShellApplication (
      ((filterAttrs.empty builderArgs) // {
        inherit name;
        text = content;
      })
    )
  );
  wrap = {
    __functor = self: self.generic;
    generic = defun (with types; [ (attrs (either app drv)) (attrs app) ]) (apps:
      (builtins.mapAttrs
        (_: value:
          if (types.app.check value) then (
            types.app value
          ) else (
            final.generic (types.drv value)
          )
        )
        apps
      )
    );
    setDefault = defun (with types; [ string (attrs (either app drv)) (attrs app) ]) (defaultName: apps:
      let
        processedApps = final.wrap.generic apps;
      in (
        processedApps // { default = processedApps."${defaultName}"; }
      )
    );
  };
})
