{ config, lib, ... }@params:

let
  inherit (lib) mkForce;
  inherit (config.lib.stylix) colors;
  inherit (config.stylix) opacity fonts image;
in {
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
    settings = (import ./noctalia-settings.nix params) // {
      colors = with colors.withHashtag; {
        mPrimary = mkForce base0B;
        mSecondary = mkForce base0B;
        mTertiary = mkForce base0D;
        # Stylix colors
        mOnPrimary = base00;
        mOnSecondary = base00;
        mOnTertiary = base00;
        mError = base08;
        mOnError = base00;
        mSurface = base00;
        mOnSurface = base05;
        mHover = base04;
        mOnHover = base00;
        mSurfaceVariant = base01;
        mOnSurfaceVariant = base04;
        mOutline = base02;
        mShadow = base00;
      };
      bar.backgroundOpacity = opacity.desktop;
      bar.capsuleOpacity = opacity.desktop;
      ui.panelBackgroundOpacity = opacity.desktop;
      dock.backgroundOpacity = opacity.desktop;
      osd.backgroundOpacity = opacity.popups;
      notifications.backgroundOpacity = opacity.popups;
      ui.fontDefault = fonts.sansSerif.name;
      ui.fontFixed = fonts.monospace.name;
    };
  };
  home.file.".cache/noctalia/wallpapers.json" = {
    text = builtins.toJSON { defaultWallpaper = image; };
  };
  stylix.targets.noctalia-shell.enable = false;
}
