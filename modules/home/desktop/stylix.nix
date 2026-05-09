{ config, ... }:

{
  stylix.targets = {
    neovim.enable = false;
  };
  gtk.gtk4.theme = config.gtk.theme;
}
