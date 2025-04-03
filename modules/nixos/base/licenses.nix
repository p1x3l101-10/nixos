{ config, options, lib, ... }:

{
  # Make an option to shim the nixpkgs config
  options.system.allowedUnfree = with lib; {
    enable = mkEnableOption "Better license management";
    licenses = mkOption {
      type = with types; listOf str;
      default = [];
    };
    blockedLicenses = mkOption {
      type = with types; listOf str;
      default = [];
    };
    packages = mkOption {
      type = with types; listOf str;
      default = [];
    };
  };
  config = lib.mkIf config.system.allowedUnfree.enable {
    nixpkgs.config = {
      allowUnfreePredicate = lib.mkForce (pkg: builtins.elem (lib.getName pkg) (config.system.allowedUnfree.packages));
      allowlistedLicenses = lib.mkForce (config.system.allowedUnfree.licenses);
      blocklistedLicenses = lib.mkForce (config.system.allowedUnfree.blockedLicenses);
    };
  };
}