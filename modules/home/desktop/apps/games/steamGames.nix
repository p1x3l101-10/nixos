{ lib, ... }:

let
  steamGameTransformer = (list:
    (lib.internal.attrsets.mergeAttrs
      (builtins.map (x:
        (builtins.mapAttrs (name: gameId:
          {
            inherit name;
            exec = "steam steam://rungameid/${builtins.toString gameId}";
            icon = "steam_icon_${builtins.toString gameId}";
            terminal = false;
            type = "Application";
            categories = [ "Game" ];
            comment = "Play this game on Steam";
          }
        ) x)
      ) list)
    )
  );
in {
  xdg.desktopEntries = steamGameTransformer [
   { factorio = 427520; }
  ];
}
