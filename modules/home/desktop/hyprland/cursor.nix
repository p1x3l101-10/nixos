{ pkgs, ... }:

{
  stylix.cursor = {
    name = "rose-pine-hyprcursor";
    size = 24;
    package = pkgs.rose-pine-hyprcursor;
  };
  home.pointerCursor.hyprcursor.enable = true;
}
