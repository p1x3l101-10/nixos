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
        mSecondary = mkForce base0C;
        mTertiary = mkForce base0D;
      };
    };
  };
}
