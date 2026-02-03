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
      mPrimary = mkForce base0C;
      mSecondary = mkForce base0D;
      mTertiary = mkForce base0B;
    };
    plugins = {
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        privacy-indicator = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
      version = 1;
    };
    pluginSettings = {
      privacy-indicator = {
        hideInactive = true;
        iconSpacing = 4;
        removeMargins = false;
      };
    };
  };
  systemd.user.services.noctalia-shell.Service.Environment = [
    "QS_ICON_THEME=\"${config.stylix.icons."${config.stylix.polarity}"}\""
  ];
}
