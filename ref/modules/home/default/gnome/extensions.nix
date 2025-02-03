{ pkgs, ... }:
{
  dconf.settings = {
    # ...
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "true-color-window-invert@lynet101"
        "wireless-hid@chlumskyvaclav.gmail.com"
        "reorder-workspaces@jer.dev"
        "NotificationCounter@coolllsk"
        "do-not-disturb-while-screen-sharing-or-recording@marcinjahn.com"
        "caffeine@patapon.info"
        "AlphabeticalAppGrid@stuarthayhurst"
        "rounded-window-corners@yilozt"
        "light-style@gnome-shell-extensions.gcampax.github.com"
        "gamemode@christian.kellner.me"
        "blur-my-shell@aunetx"
        "batterytime@typeof.pw"
        "autohide-battery@sitnik.ru"
        "legacyschemeautoswitcher@joshimukul29.gmail.com"
        "rounded-window-corners@yilozt"
        "wintile@nowsci.com"
        "pip-on-top@rafostar.github.com"
        "power-profile-indicator@laux.wtf"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "custom-accent-colors@demiskp"
        "rounded-window-corners@fxgn" # Stateful install method, needed anyways
      ];
    };
  };

  home.packages = with pkgs.gnomeExtensions; [
    true-color-window-invert
    wireless-hid
    reorder-workspaces
    notification-counter
    do-not-disturb-while-screen-sharing-or-recording
    keep-awake
    caffeine
    alphabetical-app-grid
    rounded-window-corners
    light-style
    gamemode-indicator-in-system-settings
    blur-my-shell
    battery-time-2
    autohide-battery
    legacy-gtk3-theme-scheme-auto-switcher
    pip-on-top
    power-profile-indicator
    custom-accent-colors
    # rounded-window-corners reborn # Not packaged yet
  ];
  dconf.settings = {
    "org/gnome/shell/extensions/blur-my-shell/panel".blur = false;
    "org/gnome/shell/extensions/caffeine".countdown-timer = "15";
    "org/gnome/shell/extensions/custom-accent-colors" = {
      theme-gtk3 = true;
      theme-shell = true;
      theme-flatpak = true;
      accent-color = "default";
    };
    "org/gnome/shell/extensions/user-theme".name = "Custom-Accent-Colors";
  };
}
