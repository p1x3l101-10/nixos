{ lib, ... }:
{
  _module.args = {
    globals = {
      type = "desktop";
    };
  };
  imports = [
    ./adb.nix
    ./cleanup.nix
    ./home-licences.nix
    ./home.nix
    ./ipfs.nix
    ./kernel.nix
    ./kmscon.nix
    ./modpack-working.nix
    ./impermanence.nix
    ./nebula.nix
    ./nushell.nix
    ./nix-exper.nix
    ./nix-ld.nix
    ./nix.nix
    ./nss.nix
    #./ollama.nix
    ./plymouth.nix
    ./powerManagement.nix
    ./printing.nix
    ./samba.nix
    ./silence.nix
    ./sound.nix
    ./stylix.nix
    ./tablet.nix
    ./vCamera.nix
    #./vr-min.nix
    ./vr.nix

    ./desktop/flatpak.nix
    #./desktop/fonts.nix
    #./desktop/gnome.nix
    ./desktop/hyprland.nix
    ./desktop/syncthing.nix
    ./desktop/waydroid.nix

    ./games/steam.nix
  ];
}
