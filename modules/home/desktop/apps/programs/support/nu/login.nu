# Autostart desktop
do { uwsm check may-start }
if ($env.LAST_EXIT_CODE == 0) {
  clear
  $env.UWSM_SILENT_START = 1
  exec uwsm start -e -D Hyprland hyprland.desktop -g -1
}
