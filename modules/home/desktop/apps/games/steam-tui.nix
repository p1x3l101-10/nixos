{ pkgs, ... }:

{
  home.packages = with pkgs; [
    steam-tui
    steamcmd
  ];
  home.allowedUnfree.packages = [
    "steamcmd"
  ];
}
