{ pkgs, ... }:

{
  virtualisation.waydroid.enable = true;
  # Tell waydroid to use memfd and not ashmem
  systemd.tmpfiles.settings."99-waydroid-settings"."/var/lib/waydroid/waydroid_base.prop".C = {
    user = "root";
    group = "root";
    mode = "0644";
    argument = builtins.toString (pkgs.writeText "waydroid_base.prop" ''
      sys.use_memfd=true
    '');
  };
}
