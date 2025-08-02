{ ... }:

{
  programs.kitty = {
    enable = true;
  };
  home.sessionVariables = {
    TERMINAL = "kitty";
    TERM = "kitty";
  };
}
