{ config, lib, options, ... }:
let
  cfg = config.programs.prismlauncher;

  mkInstanceOptions = _: {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        description = lib.mkDoc "The name of the instance in the PrismLauncher folder";
      };
      dotMinecraft = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = lib.mkDoc "If the instance folder has a .minecraft as its root, defaults to true";
      };
    };
  };
in
{
  options.programs.prismlauncher = with lib; {
    enable = mkEnableOption "Prismlauncher";
    instanceShortcuts = mkOption {
      type = with types; listOf (coercedTo str (name: { inherit name; }) (submodule mkInstanceOptions));
      default = [ ];
      example = literalExpression ''
        [
          "TerraFirmaGreg"
          { name = "1.12.2; dotMinecraft = false; }
        ]
      '';
    };
  };

  config = lib.mkIf cfg.enable { };
}
