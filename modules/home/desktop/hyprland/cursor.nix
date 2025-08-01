{ pkgs, ... }:

{
  home.pointerCursor = {
    enable = true;
    name = "rose-pine-hyprcursor";
    size = 24;
    package = pkgs.rose-pine-hyprcursor;
    gtk.enable = true;
    hyprcursor.enable = true;
    x11.enable = true;
  };
}
