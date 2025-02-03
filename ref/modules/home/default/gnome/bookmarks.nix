{ config, lib, ... }:

{
  gtk.gtk3.bookmarks = lib.forEach [
    "Camera"
    "Games"
    "Misc-NoSync"
    "Programs"
    "Projects"
    "Sync"
    "VMs"
  ]
    (dir: "file://" + config.home.homeDirectory + (builtins.toString dir));
}
