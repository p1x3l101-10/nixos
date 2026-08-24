# Autostart desktop
do { uwsm check may-start }
if ($env.LAST_EXIT_CODE == 0) {
  clear
  exec systemd-cat -t uwsm_start uwsm start -e -D Hyprland hyprland.desktop -g -1
}
