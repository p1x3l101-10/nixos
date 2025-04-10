{ pkgs, lib, inputs, ... }:

lib.fix (self:{
  system.autoUpgrade = {
    flags = [ "--show-trace" ];
    flake = "github:p1x3l101-10/nixos";
    allowReboot = true;
    rebootWindow = {
      upper = "03:00";
      lower = "03:30";
    };
    operation = "boot";
    persistent = true;
    dates = "daily";
  };
  systemd.services.nixos-upgrade-pre = {
    description = "NixOS Upgrade Signaler";
    serviceConfig.Type = "oneshot";
    path = with pkgs; [
      coreutils
      gitMinimal
    ];
    script = ''
      upstream_version="$(git ls-remote https://github.com/p1x3l101-10/nixos.git HEAD | head -n1 | cut -f1)"
      version="$(cat /etc/version)"
      if [ "$version" -ne "$upstream_version" ]; then
        if [ ! -e /pending-update ]; then
          touch /pending-update
        fi
      fi
    '';
  };
  environment.etc.version.text = inputs.self.sourceInfo.rev;
})