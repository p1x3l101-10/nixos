{ config, ... }:
{
  imports = [
    ./cpu.nix
    ./hardware-configuration.nix
    ./kvm.nix
    ./disko-config.nix
    ./lighting.nix
    ./network.nix
  ];
  networking.hostName = "pixels-pc";
  environment.etc.machine-id.text = "c2b9de128d004668baadd6bd861149ad";
  networking.hostId = "c2b9de12";

  # Some games need specific settings, and I am not putting this on something like a laptop
  ## Star Citizen
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };
  zramSwap = {
    enable = true;
    priority = 6;
    algorithm = "zstd";
  };

  # Begin host fixes:
  #systemd.oomd.enable = false;
  #systemd.services."systemd-timesyncd".serviceConfig.ProtectKernelModules = "no";
}
