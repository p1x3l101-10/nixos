{ lib, pkgs, ... }:

{
  services.preload.enable = true;
  environment.persistence."/nix/host/state/System".directories = [
    "/var/lib/private/preload"
  ];
  systemd.services.preload.serviceConfig.EnvironmnentFile = lib.mkForce (builtins.toFile "preload.env" ''
    MIN_MEMORY="256"
    PRELOAD_OPTS="--verbose 1 --config /etc/preload.conf"
    IONICE_OPTS="-c3"
  '');
  environment.etc."preload.conf".source = (pkgs.formats.ini { }).generate "preload config" {
    model = {
      cycle = 20;
      usecorrelation = true;
      minsize = 2000000;
      memtotal = -10;
      memfree = 50;
      memcached = 0;
    };
    system = {
      doscan = true;
      dopredict = true;
      autosave = 3600;
      mapprefix = builtins.concatStringsSep ";" [
        "/run/current-system/sw/lib"
        "/var/cache"
        "!/"
      ];
      exeprefix = builtins.concatStringsSep ";" [
        "/run/current-system/sw/bin"
        "!/"
      ];
      processes = 30;
      sortstratagy = 3;
    };
  };
}
