{ pkgs, ... }:
{
  environment.persistence."/nix/host/state/System" = {
    hideMounts = true;
    directories = [
      "/var/lib/nixos"
      "/etc/NetworkManager/system-connections"
      "/var/lib/bluetooth"
      "/var/log" # Keep logs for later review
      "/var/lib/systemd"
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
      "/root/.local/share/nix"
    ];
  };
  system.etc.overlay = {
    enable = true;
    mutable = false;
  };
  services.userborn.enable = true;
  environment.etc = {
    "containers/network".source = (pkgs.runCommand "empty-dir" {} "mkdir -p $out");
    "NetworkManager/system-connections".source = (pkgs.runCommand "empty-dir" {} "mkdir -p $out");
  };
}
