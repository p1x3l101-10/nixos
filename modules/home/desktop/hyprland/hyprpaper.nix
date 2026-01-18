{ lib, ... }:

{
  services.hyprpaper = {
    enable = lib.mkForce false;
    settings = {
      splash = false;
    };
  };
}
