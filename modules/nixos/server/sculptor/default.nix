{ lib, ... }:

# This is the only file that configures the actual host, the rest is for the container

let
  # Habit
  cfg.enable = true;
in {
  config = lib.modules.mkIf cfg.enable (lib.internal.attrsets.mergeAttrs [
    {
      containers.sculptor = {
        autoStart = true;
        privateNetwork = true;
        localAddress = "10.10.10.4/24";
        hostBridge = "br0";
        ephemeral = true;
        forwardPorts = [
          {
            containerPort = 443;
            hostPort = 25575;
            protocol = "tcp";
          }
        ];
        bindMounts = {
          "/nix/host/state/Servers/Sculptor" = {
            mountPoint = "/var/lib/private/sculptor";
            hostPath = "/nix/host/state/Servers/Sculptor";
            isReadOnly = false;
          };
          "/run/secrets/nginx" = {
            hostPath = "/nix/host/keys/nginx-certs";
            isReadOnly = false;
          };
        };
        config = { ... }: { imports = [ ./container.nix ]; };
      };
      networking.firewall.allowedTCPPorts = [ 25575 ]; # Maps to 25575 externally
    }
    {
      systemd.tmpfiles.settings = {
        "50-host-state"."/nix/host/state/Servers/Sculptor".d = { mode = "0700"; };
        "50-host-keys"."/nix/host/keys/nginx-certs".d = { mode = "0700"; };
      };
    }
  ]);
}