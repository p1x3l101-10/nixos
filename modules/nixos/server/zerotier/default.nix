{ ... }:

{
  system.allowedUnfree.packages = [
    "zerotierone"
  ];
  services.zerotierone = {
    enable = true;
    joinNetworks = [ "272f5eae16a9e125" ];
  };
  environment.persistence."/nix/host/state/Servers/ZeroTier".directories = [
    { directory = "/var/lib/zerotier-one"; mode = "0700"; }
  ];
}