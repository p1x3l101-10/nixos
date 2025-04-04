{ pkgs, ... }:
{
  environment.persistence."/nix/host/state/System".directories = [
    "/var/lib/systemd/home"
    "/var/cache/systemd/home"
  ];
  services.homed.enable = true;
  system.fsPackages = with pkgs; [
    btrfs-progs
    cryptsetup
  ];
  systemd.services.fix-accountsservice-pixel = {
    description = "Fix avatar for pixel in AccountsService after it gets clobbered";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "fix-pixel-avatar" ''
        set -euo pipefail
        mkdir -p /var/lib/AccountsService/icons/homed
        ln -sf /var/cache/systemd/home/pixel/avatar /var/lib/AccountsService/icons/homed/pixel

        cat > /var/lib/AccountsService/users/pixel <<EOF
[User]
Session=
Icon=/var/lib/AccountsService/icons/homed/pixel
SystemAccount=false
EOF
      '';
    };
  };

  systemd.paths.fix-accountsservice-pixel = {
    wantedBy = [ "multi-user.target" ];
    pathConfig = {
      PathChanged = "/var/lib/AccountsService/users/pixel";
    };
  };

  system.nssDatabases = {
    passwd = [ "systemd" "files" ];
    group = [ "systemd" "files" ];
  };
}
