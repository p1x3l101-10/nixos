{ pkgs, ... }:
{
  home.packages = [ pkgs.obs-cli ];
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
      obs-vkcapture
      obs-vertical-canvas
    ];
  };
}
