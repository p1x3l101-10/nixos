{ ... }:
let
  pfp = "stock_okuu.jpeg";
  wallpaper = "__original_drawn_by_ruanjia__sample-6c72460720cf74cbd880b6052e4144c0.jpg";
in
{
  home.file.".face".source = ./resources/user-pictures/faces + ("/" + pfp);

  xdg.configFile = {
    "wallpaper".source = ./resources/user-pictures/wallpapers + ("/" + wallpaper);
    "wallpaper-dark".source = ./resources/user-pictures/wallpapers + ("/" + wallpaper);
  };
  home.file.".background-image".source = ./resources/user-pictures/wallpapers + ("/" + wallpaper);
}
