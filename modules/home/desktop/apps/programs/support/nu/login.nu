# Start hyprland on tty1 automatically
if ((tty) | str contains tty1) {
  clear
  exec uwsm start -e -D Hyprland hyprland.desktop -g -1
  | ignore
}
