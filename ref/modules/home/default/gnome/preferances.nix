{ config, pkgs, lib, ... }:
let
  cfg.clock-format = "12h";
in

with lib.hm.gvariant;
{
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Epiphany.desktop"
        "com.raggesilver.BlackBox.desktop"
        "org.gnome.Nautilus.desktop"
        "net.nokyan.Resources.desktop"
        "steam.desktop"
        "firefox-school.desktop"
        "info.febvre.Komikku.desktop"
        "dev.alextren.Spot.desktop"
        "vesktop.desktop"
      ];
      last-selected-power-profile = "performance";
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = true;
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file://${config.xdg.configHome}/wallpaper";
      picture-uri-dark = "file://${config.xdg.configHome}/wallpaper-dark";
    };
    "org/gnome/mutter".dynamic-workspaces = true;
    "org/gnome/desktop/interface".gtk-theme = "adw-gtk3-dark";
    "org/gnome/desktop/interface".clock-format = cfg.clock-format;
    "org/gtk/settings/file-chooser".clock-format = cfg.clock-format;
    "org/gnome/desktop/peripherals/touchpad".disable-while-typing = false;
    "org/gnome/settings-daemon/plugins/power".sleep-inactive-ac-type = "nothing";
    "org/gnome/desktop/interface".show-battery-percentage = true;
    "org/gnome/desktop/peripherals/touchpad".speed = 0.35;
    "org/freedesktop/folks".primary-store = "eds:e2fc159c73c68b89db655673edaa35bd2d1ff69e";
    "org/gnome/evolution".default-address-book = "e2fc159c73c68b89db655673edaa35bd2d1ff69e";
    "org/gnome/Contacts".did-initial-setup = true;
    # God, why is this so complex, dconf usually is simple!
    "org/gnome/shell/weather".locations = [
      (mkVariant (mkTuple [
        (mkUint32 2)
        (mkVariant (mkTuple [
          "Oklahoma City"
          "KOKC"
          true
          [ (mkTuple [ (0.61764777965748296) (-1.703446201961786) ]) ]
          [ (mkTuple [ (0.61902569964864007) (-1.7019827433839889) ]) ]
        ]))
      ]))
    ];
    "org/gnome/evolution/mail" = {
      prompt-check-if-default-mailer = false;
      image-loading-policy = "always";
      show-animated-images = true;
      load-http-images = 2;
      show-sender-photo = true;
      search-gravatar-for-photo = true;
      send-recv-all-on-start = true;
      composer-mode = "markdown";
      composer-unicode-smileys = true;
      composer-spell-languages = [ "en_US" ];
      prompt-on-mark-as-junk = false;
    };
    "org/gnome/evolution-data-server".limit-operations-in-power-saver-mode = true;
    "org/gnome/desktop/interface".icon-theme = "MoreWaita";
    "hu/kramo/Cartridges" = {
      desktop = false;
      flatpak = false;
      heroic = false;
      itch = false;
      legendary = false;
      lutris = false;
      retroarch = false;
      sgdb = true;
      sgdb-animated = true;
      sgdb-key = "e14cd94b92703ac06b2f52a89576f972";
      sgdb-prefer = true;
    };
    "org/gnome/desktop/input-sources".xkb-options = [ "terminate:ctrl_alt_bksp" "compose:menu" ];
    "org/freedesktop/tracker/miner/files" = {
      index-recursive-directories = [
        "&DESKTOP"
        "&DOCUMENTS"
        "&MUSIC"
        "&PICTURES"
        "&VIDEOS"
        "&DOWNLOAD"
        "/home/pixel/Sync"
        "/home/pixel/Misc-NoSync"
        "/home/pixel/Games"
        "/home/pixel/Camera"
        "/home/pixel/Programs"
        "/home/pixel/Projects"
        "/home/pixel/Public"
      ];
      index-single-directories = [
        "&HOME"
      ];
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  gtk.iconTheme = {
    name = "MoreWaita";
    package = pkgs.morewaita-icon-theme;
  };
  home.packages = [ pkgs.morewaita-icon-theme ];
}
