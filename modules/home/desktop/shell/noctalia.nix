{ config, lib, ... }@params:

let
  inherit (lib) mkForce;
in {
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
    settings = (import ./noctalia-settings.nix params) // {
      colors = with config.lib.stylix.colors.withHashtag; {
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
    };
  };
}
