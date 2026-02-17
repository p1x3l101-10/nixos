{ pkgs, lib, globals, ... }:

let
  mountUnit = what: where: {
    inherit what where;
    type = "none";
    options = "bind";
    wantedBy = [ "local-fs.target" ];
  };
  imperSubst = dir: (mountUnit "/nix/host/state/System/${dir}" dir);
in
{
  environment.persistence."/nix/host/state/System" = {
    hideMounts = true;
    directories = [
      "/var/lib/nixos"
      "/var/lib/bluetooth"
      "/var/log" # Keep logs for later review
      "/var/lib/systemd"
      "/var/lib/userborn" # Prevent stupid uid changes from daring to alter a service
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
      "/root/.local/share/nix"
    ];
  };
  systemd.mounts = [
    (imperSubst "/etc/NetworkManager/system-connections")
    (imperSubst "/etc/avahi")
  ];
  system.etc.overlay = {
    enable = true;
    mutable = true;
  };
  services.userborn.enable = true;
  environment.etc = {
    "containers/networks/.keep".source = (pkgs.runCommand "empty-file" { } "touch $out");
    "NetworkManager/system-connections/.keep".source = (pkgs.runCommand "empty-file" { } "touch $out");
    "avahi/.keep".source = (pkgs.runCommand "empty-file" { } "touch $out");
  };
}
