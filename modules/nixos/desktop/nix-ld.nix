{ pkgs, inputs, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      alsa-lib.out
      dbus.lib
      libGL.out
      fontconfig.lib
      openxr-loader.out
      pipewire.out
      libgcc.lib
      kdePackages.wayland.out
      xorg.libX11.out
      xorg.libxcb.out
      xorg.libXext.out
      libxkbcommon.out
      xorg.libXrandr.out
    ];
  };
  environment.systemPackages = [
    inputs.nix-autobahn.packages.x86_64-linux.nix-autobahn
  ];
}
