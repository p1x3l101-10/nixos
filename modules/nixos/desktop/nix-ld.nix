{ pkgs, inputs, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      alsa-lib
      dbus.lib
      libGL
      fontconfig.lib
      openxr-loader
      pipewire
      libgcc.lib
      kdePackages.wayland
      xorg.libX11
      xorg.libxcb
      xorg.libXext
      libxkbcommon
      xorg.libXrandr
      e2fsprogs
      libdrm
      expat
      freetype
      fribidi
      libgbm
      libgpg-error
      harfbuzz
      libz
      fuse
    ];
  };
  environment.systemPackages = [
    inputs.nix-autobahn.packages.x86_64-linux.nix-autobahn
    nix-index
    fuse
  ];
}
