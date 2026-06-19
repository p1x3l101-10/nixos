{ lib, ... }:

let
  mkHpka = attrs: lib.hm.generators.toHyprconf { inherit attrs; importantPrefixes = [ "$" ]; };
in {
  services.hyprpolkitagent.enable = true;
  xdg.configFile."hyprpolkitagent/hyprpolkitagent.conf".text = mkHpka {
    general = {
      show_details = true;
    };
  };
}
