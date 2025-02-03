{ ... }:
{
  environment.persistence."/nix/host/state/System" = {
    hideMounts = true;
    directories = [
      "/var/lib/nixos"
      "/etc/NetworkManager/system-connections"
      "/var/lib/bluetooth"
      "/var/log" # Keep logs for later review
      "/var/lib/systemd/coredump" # Same thing
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
      "/root/.local/share/nix"
    ];
  };
}
