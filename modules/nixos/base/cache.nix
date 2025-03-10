{ pkgs, ... }:
{
  environment.persistence."/nix/host/cache".directories = [
    "/var/tmp"
    "/var/cache"
    "/tmp"
  ];
  # Clear cache on reboot
  boot.initrd.systemd.services.moveSystemCache = {
    description = "Clean system disk cache (Stage 1)";
    script = ''
      ${pkgs.coreutils}/bin/mv -v /sysroot/nix/host/cache /sysroot/nix/host/.cache.old && \
      ${pkgs.coreutils}/bin/mkdir /sysroot/nix/host/cache
      echo "Sucessfully cleaned cache!"
    '';
    wantedBy = [ "initrd.target" ];
    after = [ "initrd-root-fs.target" ];
    unitConfig = {
      RequiresMountsFor = "/sysroot/nix";
      Type = "Oneshot"; # Ensure this task is completed before system boot
    };
  };
  systemd.services.clearOldCache = {
    description = "Clean system disk cache (Stage 2)";
    script = ''
      ${pkgs.coreutils}/bin/rm -rfv /nix/host/.cache.old && \
      echo "Sucessfully cleared old cache!"
    '';
    wantedBy = [ "multi-user.target" ];
  };
}
