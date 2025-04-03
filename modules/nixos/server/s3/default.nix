{ lib, ... }:

# This is the only file that configures the actual host, the rest is for the container

let
  # Habit
  cfg.enable = false;
in {
  config = lib.modules.mkIf cfg.enable (lib.nixos-home.attrsets.mergeAttrs [
    {
      containers.s3 = {
        autoStart = true;
        privateNetwork = true;
        localAddress = "10.10.10.3/24";
        hostBridge = "br0";
        ephemeral = true;
        bindMounts = {
          "/nix/host/keys/minio".isReadOnly = false;
          "/var/lib/minio" = {
            isReadOnly = false;
            hostPath = "/nix/host/state/Servers/Minio";
          };
        };
        config = { ... }: { imports = [ ./container.nix ]; };
      };
    }
    {
      systemd.tmpfiles.settings."50-host-state"."/nix/host/state/Servers/Minio".d = { mode = "0755"; };
    }
    (lib.internal.sss.makeTmpFiles [
      "nextcloud"
    ])
  ]);
}