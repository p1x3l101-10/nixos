{ config, lib, ... }@params:

let
  inherit (lib) mkForce;
  inherit (config.lib.stylix) colors;
in {
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
    settings = import ./noctalia-settings.nix params;
    colors = with colors.withHashtag; {
      mPrimary = mkForce base0B;
      mSecondary = mkForce base0B;
      mTertiary = mkForce base0D;
    };
  };
  systemd.user.services.noctalia-shell.Service.Environment = [
    "QS_ICON_THEME=\"${config.stylix.icons."${config.stylix.polarity}"}\""
  ];
}
