{ pkgs, lib, ... }:

{
  stylix.cursor = {
    name = "rose-pine-cursor";
    size = 24;
    package = pkgs.buildEnv {
      name = "rose-pine-cursor-merged";
      paths = with pkgs; [
        rose-pine-hyprcursor
        rose-pine-cursor
      ];
    };
  };
  home.sessionVariables.HYPRCURSOR_THEME = lib.mkForce "rose-pine-hyprcursor";
  home.pointerCursor.hyprcursor.enable = true;
}
