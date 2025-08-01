{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rose-pine-hyprcursor
  ];
  systemd.user.sessionVariables = rec {
    HYPRCURSOR_THEME = "rose-pine-hyprcursor";
    HYPRCURSOR_SIZE = "24";
    XCURSOR_SIZE = HYPRCURSOR_SIZE;
  };
}
