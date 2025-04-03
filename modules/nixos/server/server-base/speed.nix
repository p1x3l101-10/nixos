{ ... }:
{
  systemd.mounts = [{
    enable = false;
    where = "/sys/kernel/config";
  }];
  boot.initrd.systemd.mounts = [{
    enable = false;
    where = "/sys/kernel/config";
  }];
}
