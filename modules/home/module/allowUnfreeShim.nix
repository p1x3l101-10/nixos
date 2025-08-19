{ lib, ... }:

{
  # A shim so that I can propigate this setting back down to my nixos config
  # Can also be used in a standalone config, see the nixos version of this on how to use it
  options.home.allowedUnfree = with lib; {
    enable = mkEnableOption "Better license management" // { default = true; };
    # NOTE: This breaks when merged into nixos config, hence why it is commented out. In a standalone version, it is perfectly safe to use these
    /*
      licenses = mkOption {
      type = with types; listOf str;
      default = [ ];
      };
      blockedLicenses = mkOption {
      type = with types; listOf str;
      default = [ ];
      };
    */
    packages = mkOption {
      type = with types; listOf str;
      default = [ ];
    };
  };
}
