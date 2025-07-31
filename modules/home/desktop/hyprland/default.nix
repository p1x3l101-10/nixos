{ ... }:

{
  illogical-impulse = {
    # Enable the dotfiles suite
    enable = true;

    hyprland = {
      # Use customized Hyprland build
      package = hypr.hyprland;
      xdgPortalPackage = hypr.xdg-desktop-portal-hyprland;

      # Enable Wayland ozone
      ozoneWayland.enable = true;
    };

    # Dotfiles configurations
    dotfiles = {
      anyrun.enable = true;
      fish.enable = true;
      kitty.enable = true;
    };
  };
}
