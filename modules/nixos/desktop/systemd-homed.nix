{ pkgs, ... }:
{
  environment.persistence."/nix/host/state/systemd-homed".directories = [
    "/var/lib/systemd/home"
    "/var/cache/systemd/home"
  ];
  services.homed.enable = true;
  system.fsPackages = with pkgs; [
    btrfs-progs
    cryptsetup
  ];
}
