{ lib, ... }:

# This is the only file that configures the actual host, the rest is for the container

let
  # Habit
  cfg.enable = false;
in {
  config = lib.modules.mkIf cfg.enable (lib.nixos-home.attrsets.mergeAttrs [
    {
      containers.ftp = {
        autoStart = true;
        privateNetwork = true;
        localAddress = "10.10.10.4/24";
        hostBridge = "br0";
        ephemeral = true;
        bindMounts = {
          "/var/lib/ftp" = {
            isReadOnly = false;
            hostPath = "/nix/host/state/Servers/FTP";
          };
        };
        config = { ... }: { imports = [ ./container.nix ]; };
      };
    }
    {
      systemd.tmpfiles.settings."50-host-state"."/nix/host/state/Servers/FTP".d = { mode = "0755"; };
    }
  ]);
}