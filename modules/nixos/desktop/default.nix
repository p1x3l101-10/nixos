{ ... }:
{
  _module.args = {
    globals = {
      type = "desktop";
    };
  };
  imports = [
    ./ipfs.nix
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
    ./tailscale.nix
    ./vCamera.nix
    ./vr.nix

    ./desktop/flatpak.nix
    ./desktop/fonts.nix
    ./desktop/gnome.nix
    ./desktop/syncthing.nix
    ./desktop/waydroid.nix
  ];
}
