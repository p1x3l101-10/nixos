{ lib, osConfig, ... }:

let
  steamGameTransformer = (list:
    (lib.internal.attrsets.mergeAttrs
      (builtins.map
        (x:
          (builtins.mapAttrs
            (name: gameId:
              {
                inherit name;
                exec = "steam steam://rungameid/${builtins.toString gameId}";
                icon = "steam_icon_${builtins.toString gameId}";
                terminal = false;
                type = "Application";
                categories = [ "Game" ];
                comment = "Play this game on Steam";
              }
            )
            x)
        )
        list)
    )
  );
in
{
  xdg.desktopEntries = steamGameTransformer ([
    { Factorio = 427520; }
    { Terraria = 105600; }
    { tModLoader = 1281930; }
  ] ++ (lib.lists.optionals (osConfig.networking.hostName == "pixels-pc") [
    { "Portal 2" = 620; }
    { "Deep Rock Galactic" = 548430; }
    { Volcanoids = 951440; }
    { "No Man's Sky" = 275850; }
    { Satisfactory = 526870; }
    { ULTRAKILL = 1229490; }
    { Starbound = 211820; }
    { Forts = 410900; }
    { Stellaris = 281990; }
  ]));
}
