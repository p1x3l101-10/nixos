{ pkgs, ... }:
{
    environment.persistence."/nix/host/cache".directories = [
        "/var/tmp"
        "/var/cache"
        "/tmp"
    ];
    disko.devices.nodev."/var/lib/containers" = {
        fsType = "tmpfs";
        mountOptions = [ "defaults" "size=5G" "mode=755" ];
    };
    # Clear cache on reboot
    /*
    boot.initrd.systemd.services.cleanSystemCache = {
        description = "Clean system disk cache";
        script = "${pkgs.coreutils}/bin/rm -rfv /sysroot/nix/host/cache";
        wantedBy = [ "initrd.target" ];
        after = [ "initrd-root-fs.target" ];
        unitConfig = {
            RequiresMountsFor = "/sysroot/nix";
            Type = "Oneshot";
            RemainAfterExit = true;
        };
    };*/
    boot.initrd.systemd.tmpfiles.settings."00-clean-cache"."/sysroot/nix/host/cache".R.argument = "0";
}