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
  filterEmpty = defun (with types; [ (attrs (option any)) (attrs any) ]) (attrs:
    builtins.listToAttrs (
      builtins.filter
      (x: !builtins.isNull x)
      (lib.attrsToList attrs)
    )
  );
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
      ((filterEmpty builderArgs) // {
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
      ((filterEmpty builderArgs) // {
        inherit name;
        text = content;
      })
    )
  );
})
