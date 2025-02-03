{ ... }:
{
  system.autoUpgrade = {
    flags = [ "--show-trace" ];
    flake = "gitlab:pixel-101/nixos-config";
    allowReboot = true;
    rebootWindow = {
      upper = "03:00";
      lower = "03:30";
    };
    persistent = true;
    dates = "daily";
  };
}
