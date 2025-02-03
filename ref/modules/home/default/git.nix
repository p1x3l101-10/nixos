{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Pixel";
    userEmail = "scott.blatt.0b10@gmail.com";
    aliases = {
      ci = "commit";
      co = "checkout";
      s = "status";
      pu = "push";
      pl = "pull";
    };
    lfs.enable = true;
  };
}
