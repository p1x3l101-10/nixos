{ ... }:
{
  _module.args = {
    globals = {
      type = "desktop";
    };
  };
  imports = [
    ./adb.nix
    ./ipfs.nix
    ./kernel.nix
    ./modpack-working.nix
    ./impermanence.nix
    ./nebula.nix
    ./nix-exper.nix
    ./nix-ld.nix
    ./nix.nix
    ./nss.nix
    ./ollama.nix
    ./plymouth.nix
    ./powerManagement.nix
    ./printing.nix
    ./samba.nix
    ./silence.nix
    ./sound.nix
    ./systemd-homed.nix
    ./tablet.nix
    ./vCamera.nix
    #./vr-min.nix
    ./vr.nix

    ./desktop/flatpak.nix
    ./desktop/fonts.nix
    ./desktop/gnome.nix
    ./desktop/syncthing.nix
    ./desktop/waydroid.nix

    ./games/minecraft.nix
    ./games/steam.nix
  ];
}
