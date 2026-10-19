{ ext, pkgs, lib, osConfig, ... }:

rec {
  globals = import ../hypr-globals.nix { inherit pkgs lib ext; };
  inherit (lib.generators) mkLuaInline;
  mkArgs = args: {
    _args = args;
  };
  inherit (import ../luaCmds.nix { inherit lib; }) hl;
  monitors = (
    let
      inherit (osConfig.networking) hostName;
      mkMon = attrs: (
        if (builtins.hasAttr hostName attrs) then (attrs."${hostName}") else null
      );
      mkCount = attrs: (
        if (builtins.hasAttr hostName attrs) then (attrs."${hostName}") else 1
      );
    in {
      count = mkCount {
        stellar-pc = 2;
      };
      primary = mkMon {
        stellar-pc = {
          name = "DP-1";
          offset = "0x0";
        };
      };
      secondary = mkMon {
        stellar-pc = {
          name = "DP-2";
          offset = "-1920x0";
        };
      };
    }
  );
  functions = lib.fix (final: {
    keys = lib.fix (finalKeys: {
      special = class: code: "${class}:${builtins.toString code}";
      mouse = {
        left = finalKeys.special "mouse" 272;
        right = finalKeys.special "mouse" 273;
        middle = finalKeys.special "mouse" 274;
      };
    });
    bind = lib.fix (finalBind: {
      bind = (
        { keys
        , dispatcher
        , options ? { }
        , autoMod ? true
        }:
        mkArgs [
          # All this does is process the keys to something hyprland can take
          # Optionally lets the keys be as a list
          # Also handles automatically adding the modifier key when enabled
          ( 
            if (builtins.isList keys) then (
              builtins.concatStringsSep " + " (
                (
                  if (autoMod && (!builtins.elem globals.modifierKey keys)) then (
                    [ globals.modifierKey ]
                        ) else ([])
                ) ++ keys
              )
            ) else (
              if (autoMod && (!lib.strings.hasInfix globals.modifierKey keys)) then (
                globals.modifierKey + " + " + keys
              ) else keys
            )
          )
          dispatcher
          options
        ]
      );
      b = keys: dispatcher: finalBind.bind { inherit keys dispatcher; };
      bnm = keys: dispatcher: finalBind.bind { inherit keys dispatcher; autoMod = false; };
      b' = keys: dispatcher: options: finalBind.bind { inherit keys dispatcher options; };
      bnm' = keys: dispatcher: options: finalBind.bind { inherit keys dispatcher options; autoMod = false; };
    });
  });
}
