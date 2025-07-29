{ pkgs, lib, ... }: # Lib not needed usually, but is very nice for fakeHash later

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    withRuby = true;
    withPython3 = true;
    withNodeJs = true;
  };
  fonts.packages = with pkgs; [
    nerd-fonts.sauce-code-pro
  ];
  environment.systemPackages = with pkgs; [
    tree-sitter
    ripgrep
    lazygit
    gdu
    bottom
  ];
}
