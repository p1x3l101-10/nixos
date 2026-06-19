# Start hyprland on tty1 automatically
if ((tty) | str contains tty1) {
  exec uwsm start -e -D Hyprland hyprland.desktop
}
