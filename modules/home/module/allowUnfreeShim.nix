{ lib, ... }:

{
  # A shim so that I can propigate this setting back down to my nixos config
  # Can also be used in a standalone config, see the nixos version of this on how to use it
  options.system.allowedUnfree = with lib; {
    enable = mkEnableOption "Better license management" // { default = true; };
    licenses = mkOption {
      type = with types; listOf str;
      default = [ ];
    };
    blockedLicenses = mkOption {
      type = with types; listOf str;
      default = [ ];
    };
    packages = mkOption {
      type = with types; listOf str;
      default = [ ];
    };
  };
}
