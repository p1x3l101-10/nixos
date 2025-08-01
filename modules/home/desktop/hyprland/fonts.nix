{ pkgs, ... }:

{
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      emoji = [ "NotoColorEmoji" ];
      monospace = [ "SauceCodePro" ];
      sansSerif = [ "NotoSans[wdth,wght]" ];
      serif = [ "NotoSerif[wdth,wght]" ];
    };
  };
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];
}
