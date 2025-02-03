{ config, lib, ... }:

let
  ignoreApps = [
    "vim"
  ];
in

{
  xdg.desktopEntries = builtins.listToAttrs (map
    (app: {
      name = app;
      value = {
        name = app;
        noDisplay = true;
      };
    })
    ignoreApps);
}
