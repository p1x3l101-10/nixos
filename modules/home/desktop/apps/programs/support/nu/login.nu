# Autostart desktop
if (uwsm check may-start) {
  clear
  exec systemd-cat -t uwsm_start uwsm start -e -D Hyprland hyprland.desktop -g -1
}
