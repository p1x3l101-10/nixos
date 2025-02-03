{ ... }:
{
  imports = [
    ./extraPackages.nix
    ./nix.nix
    ./nss.nix
    ./secureBoot.nix
    ./plymouth.nix
    ./syncthing.nix
    ./qemu.nix
    ./home-manager.nix
    ./vCamera.nix
    ./nix-exper.nix
    ./impermanence.nix
    ./scrobbler.nix
    ./libvirt.nix
    ./sound.nix
    ./printing.nix
    ./silence.nix
    ./samba.nix

    ./desktop/gnome.nix
    ./desktop/flatpak.nix
    ./desktop/gamemode.nix
    ./desktop/fonts.nix
  ];
}
