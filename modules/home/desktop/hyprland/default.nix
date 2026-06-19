{ eLib, ... }:

{
  imports = (eLib.confTemplates.importList ./.);
  xdg.configFile."uwsm/default-id".text = "hyprland.desktop";
}
