{ config, ... }:

{
  systemd.services.nix-daemon.serviceConfig.ExecStart = "${config.nix.package.out}/bin/nix daemon";
}
