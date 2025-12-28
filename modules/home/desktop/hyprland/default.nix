{ lib, ... }:

{
  imports = (lib.internal.confTemplates.importList ./.);
  xdg.configFile."uwsm/default-id".text = "hyprland-uwsm.desktop";
}
