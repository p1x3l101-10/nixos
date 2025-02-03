{ ... }:
{
  environment.persistence."/nix/host/state".directories = [
    "/var/lib/upower"
    "/var/lib/logmein-hamachi"
  ];
  environment.persistence."/nix/host/state".users.pixel = {
    directories = [
      "Camera"
      "Documents"
      "Desktop"
      "Downloads"
      "Games"
      "Music"
      "Misc-NoSync"
      "Pictures"
      "Programs"
      "Projects"
      "Public"
      "Sync"
      "Templates"
      "Videos"
      ".local/share/gnome-control-center-goa-helper"
      ".local/share/gnome-settings-daemon"
      ".local/share/gnome-shell/extensions"
      ".local/share/nautilus"
      ".local/share/gvfs-metadata"
      ".config/goa-1.0"
      ".var/app"
      ".config/flatpak"
      ".local/share/flatpak"
      ".local/state/home-manager/gcroots"
      ".local/state/nix/profiles"
      ".config/syncthing"
      ".local/share/zoxide"
      ".local/share/nix"
      { directory = ".gnupg"; mode = "0700"; }
      { directory = ".local/share/keyrings"; mode = "0700"; }
    ];
  };
}
