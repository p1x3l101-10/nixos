{ lib, ... }:

with lib.hm.gvarient;
{
  dconf.settings = {
    "org/gnome/desktop/app-folders/folders/Games" = {
      apps = lib.forEach [
        # Steam
        "5D Chess With Multiverse Time Travel"
        "ASTRONEER"
        "Black Mesa"
        "Brawlhalla"
        "Buckshot Roulette"
        "CBT With Yuuka Kazami"
        "Christmas Celebration With Sakuya Izayoi"
        "Deep Rock Galactic"
        "Don't Starve Together"
        "Doki Doki Literature Club"
        "Factorio"
        "Forts"
        "FPS Chess"
        "FTL Faster Than Light"
        "Garry's Mod"
        "Gensokyo Night Festival"
        "Gensokyo Odyssey"
        "Half-Life 2 Deathmatch"
        "Half-Life 2 Episode One"
        "Half-Life 2 Episode Two"
        "Half-Life 2 Lost Coast"
        "Half-Life 2"
        "Half-Life"
        "Helltaker"
        "Help Me Remember, Satori-sama!"
        "I Am Sakuya Touhou FPS Game"
        "HoloCure - Save the Fans!"
        "Just Act Natural"
        "Kerbal Space Program"
        "Last Train Outta' Wormtown Friend's Pass"
        "Left 4 Dead 2"
        "Lethal Company"
        "LUFTRAUSERS"
        "Liquidators"
        "Metal Waltz"
        "Mindustry"
        "Muck"
        "NGU IDLE"
        "Nimbatus - The Space Drone Constructor"
        "No Man's Sky"
        "Outdoor Adventures With Marisa Kirisame"
        "Oxygen Not Included"
        "Nimbatus - The Space Drone Constructor"
        "Papers, Please"
        "People Playground"
        "Pizza Tower"
        "Portal 2"
        "Portal Reloaded"
        "Portal Revolution"
        "Portal Stories Mel"
        "Portal"
        "Pro Office Calculator"
        "Raft"
        "Satisfactory"
        "Sakuya Izayoi Gives You Advice And Dabs"
        "Save Me, Sakuya-san!"
        "Slime Rancher"
        "Space Engineers"
        "Starbound"
        "Stick Fight The Game"
        "Subnautica Below Zero"
        "Subnautica"
        "Sven Co-op"
        "Synergy"
        "Tabletop Simulator"
        "Team Fortress 2"
        "Terraria"
        "There is no game Jam Edition 2015"
        "TIS-100"
        "tModLoader"
        "Touhou Artificial Dream in Arcadia"
        "Touhou Danmaku Kagura Phantasia Lost"
        "Touhou Fading Illusion"
        "Touhou Genso Wanderer -Reloaded-"
        "Touhou Luna Nights"
        "TouhouHeroofIceFairy"
        "Touhou Hero of Ice Fairy Prologue"
        "Touhou Mystia's Izakaya"
        "Touhou Scarlet Curiosity"
        "ULTRAKILL"
        "Volcanoids"
        "Watermelon Game"
        "Worbital"

        # Other Games
        "osu!"
        "taisei"
      ]
        (x:
          (toString x) + ".desktop"
        );
      name = "Games";
    };
    "org/gnome/desktop/app-folders/folders/Minecraft" = {
      apps = lib.forEach [
        "org.prismlauncher.PrismLauncher"
        "TerraFirmaGreg"
        "GregTech- New Horizons"
        "GregTech Community Pack Modern"
        "Monifactory"
        "SevTech- Ages"
        "Murdering the Environment"
      ]
        (x:
          (toString x) + ".desktop"
        );
      name = "Minecraft";
    };
    "org/gnome/desktop/app-folders/folders/Steam" = {
      apps = lib.forEach [
        "steam"
        "r2modman"
        "steamtinkerlaunch"
        "protonup-qt"
        "protontricks"
        "vortex-steamtinkerlaunch-dl"
        "Proton 8.0"
        "Proton Experimental"
        "com.steamgriddb.SGDBoop"
        "Steam Linux Runtime 1.0 (scout)"
        "Steam Linux Runtime 2.0 (soldier)"
        "Steam Linux Runtime 3.0 (sniper)"
      ]
        (x:
          (toString x) + ".desktop"
        );
      name = "Steam";
    };
    "org/gnome/desktop/app-folders/folders/Gnome-Games" = {
      apps = (lib.forEach [
        "Chess"
        "five-or-more"
        "Four-in-a-row"
        "Hitori"
        "Klotski"
        "LightsOff"
        "Mahjongg"
        "Mines"
        "Nibbles"
        "Quadrapassel"
        "Reversi"
        "Robots"
        "Sudoku"
        "SwellFoop"
        "Tali"
        "Taquin"
        "Tetravex"
        "TwentyFortyEight"
      ]
        (x:
          "org.gnome." + (toString x) + ".desktop"
        )) ++ [ "atomix.desktop" "sol.desktop" ];
      name = "Gnome Games";
    };
    "org/gnome/desktop/app-folders".folder-children = [
      "Minecraft"
      "Gnome-Games"
      "Steam"
      "Games"
    ] ++ [ "Utilities" "YaST" "Pardus" ];
  };
}
