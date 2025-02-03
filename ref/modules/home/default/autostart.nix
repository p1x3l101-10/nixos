{ pkgs, lib, nixosConfig, ... }:
# Stolen from https://github.com/nix-community/home-manager/issues/3447#issuecomment-1328294558
let
  autostartPrograms =
    if (nixosConfig.system.name == "pixels-pc") then
      (with pkgs; [
        vesktop
        steam
      ]) else [ ];
in
{
  home.file = builtins.listToAttrs (map
    (pkg:
      {
        name = ".config/autostart/" + pkg.pname + ".desktop";
        value =
          if pkg ? desktopItem then {
            # Application has a desktopItem entry.
            # Assume that it was made with makeDesktopEntry, which exposes a
            # text attribute with the contents of the .desktop file
            text = pkg.desktopItem.text;
          } else {
            # Application does *not* have a desktopItem entry. Try to find a
            # matching .desktop name in /share/apaplications
            source =
              if (pkg != pkgs.steam) then # Steam doesn't have a pname???
                (pkg + "/share/applications/" + pkg.pname + ".desktop")
              else (pkg + "/share/applications/" + pkg.name + ".desktop");
          };
      })
    autostartPrograms);
}
