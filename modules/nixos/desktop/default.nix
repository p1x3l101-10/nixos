{ lib, ... }:
{
  _module.args = {
    globals = {
      type = "desktop";
      dirs = {
        state = "/nix/host/state";
        cache = "/nix/host/cache";
        keys = "/nix/host/keys";
      };
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
    ./yubikey.nix
    ./run0.nix

    ./desktop/flatpak.nix
    #./desktop/fonts.nix
    #./desktop/gnome.nix
    ./desktop/hyprland.nix
    ./desktop/syncthing.nix
    ./desktop/waydroid.nix

    ./games/steam.nix
  ];
}
