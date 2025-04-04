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
  systemd.tmpfiles.settings."99-Accountservice-fixes" = {
    "/var/lib/AccountsService/users/pixel"."C+" = {
      user = "root";
      group = "root";
      mode = "0644";
      argument = builtins.toString (pkgs.writeText "pixel-as-config" ''
        [User]
        Session=
        Icon=/var/lib/AccountsService/icons/homed/pixel
        SystemAccount=false
      '');
    };
    "/var/lib/AccountsService/icons/homed".d = {
      user = "root";
      group = "root";
      mode = "0755";
    };
    "/var/lib/AccountsService/icons/homed/pixel"."L" = {
      argument = "/var/cache/systemd/home/pixel/avatar";
    };
  };
  system.nssDatabases = {
    passwd = [ "systemd" "files" ];
    group = [ "systemd" "files" ];
  };
}
