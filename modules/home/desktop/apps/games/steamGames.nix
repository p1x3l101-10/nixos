{ lib, eLib, osConfig, ... }:

{
  xdg.desktopEntries = (eLib.attrsets.mergeAttrs
    (builtins.map
      (x:
        {
          inherit (x) name;
          exec = "steam steam://rungameid/${builtins.toString x.appid}";
          icon = "steam_icon_${builtins.toString x.appid}";
          terminal = false;
          type = "Application";
          categories = [ "Game" ];
          comment = "Play this game on Steam";
        }
      )
      (builtins.fromJSON (builtins.readFile ./support/steamGames/steamGameDb.json)))
  );
}
