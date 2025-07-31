{ ext, ... }:

let
  inherit (ext) assets;
in
{
  home.file.".face".source = assets.img."pfp.png";
}
