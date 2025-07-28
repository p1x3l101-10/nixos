{ pkgs, lib, ... }: # Lib not needed usually, but is very nice for fakeHash later

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
  };
  environment.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };
}
