{ pkgs, ... }:
{
  environment.persistence."/nix/host/cache".directories = [
    "/var/tmp"
    "/var/cache"
    "/tmp"
  ];
  # Clear cache on reboot
  boot.initrd.systemd.services.cleanSystemCache = {
    description = "Clean system disk cache";
    script = ''
      ${pkgs.coreutils}/bin/rm -rfv /sysroot/nix/host/cache
      echo "Sucessfully cleared cache!"
    ''; # NOTE: if you do not see the last line, bump the timeout number and try again
    wantedBy = [ "initrd.target" ];
    after = [ "initrd-root-fs.target" ];
    unitConfig = {
      RequiresMountsFor = "/sysroot/nix";
      Type = "Oneshot";
      RemainAfterExit = true;
      TimeoutStartSec = "300"; # Ensure there is enough time for all directories to get removed
    };
  };
}
