{ pkgs, ... }:

{
  home.packages = [(pkgs.writeShellApplication {
    name = "alfis-gui-launcher";
    text = ''
      # Needs to run as root
      if [[ $EUID -ne 0 ]]; then
        exec sudo /bin/env WAYLAND_DISPLAY="$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY"  XDG_RUNTIME_DIR=/user/run/0 $0 $@
      fi

      cd /var/lib/alfis
      systemctl stop alfis
      alfis -c /etc/alfis.toml "$@"
      systemctl start alfis
    '';
  })];
}
