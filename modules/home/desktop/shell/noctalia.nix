{ config, lib, ... }@params:

let
  inherit (lib) mkForce;
  inherit (config.lib.stylix) colors;
in {
  programs.noctalia-shell = {
    enable = true;
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
      version = 2;
    };
    pluginSettings = {
      privacy-indicator = {
        hideInactive = true;
        iconSpacing = 4;
        removeMargins = false;
      };
    };
  };
  # Screw upstream depricating systemd starting, I'm making a better service! With blackjack and hookers!
  systemd.user.services.noctalia-shell = {
    Unit = {
      Description = "Noctalia Shell - Wayland desktop shell";
      Documentation = "https://docs.noctalia.dev";
      PartOf = [ config.wayland.systemd.target ];
      After = [ config.wayland.systemd.target ];
      X-Restart-Triggers = (map
        (x: config.xdg.configFile."${x}".source)
        ([
          "noctalia/settings.json"
          "noctalia/colors.json"
          "noctalia/plugins.json"
        ] ++ (map
          (x: "noctalia/plugins/${x}/settings.json")
          [
            "privacy-indicator"
          ]
        ))
      );
    };
    Service = {
      ExecStart = lib.getExe config.programs.noctalia-shell.package;
      Restart = "on-failure";
      Environment = [
        "QS_ICON_THEME=\"${config.stylix.icons."${config.stylix.polarity}"}\""
      ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
