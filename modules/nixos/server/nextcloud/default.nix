{ lib, ... }:

# This is the only file that configures the actual host, the rest is for the container

let
  # Habit
  cfg.enable = true;
in {
  config = lib.modules.mkIf cfg.enable (lib.internal.attrsets.mergeAttrs [
    {
      containers.nextcloud = {
        autoStart = true;
        privateNetwork = true;
        localAddress = "10.10.10.4/24";
        hostBridge = "br0";
        ephemeral = true;
        forwardPorts = [
          {
            containerPort = 80;
            hostPort = 25565;
            protocol = "tcp";
          }
        ];
        bindMounts = {
          "/nix/host/state/Servers/Nextcloud" = {
            mountPoint = "/var/lib/nextcloud";
            hostPath = "/nix/host/state/Servers/Nextcloud";
            isReadOnly = false;
          };
          "/run/secrets/s3".hostPath = "/nix/host/keys/minio/keys/nextcloud";
          "/run/secrets/nextcloud" = {
            hostPath = "/nix/host/keys/nextcloud";
            isReadOnly = false;
          };
        };
        config = { ... }: { imports = [ ./container.nix ]; };
      };
      networking.firewall.allowedTCPPorts = [ 25565 ]; # Maps to 7777 externally
    }
    {
      systemd.tmpfiles.settings = {
        "50-host-state"."/nix/host/state/Servers/Nextcloud".d = { mode = "0755"; };
        "50-host-keys"."/nix/host/keys/nextcloud".d = { mode = "0700"; };
      };
    }
  ]);
}