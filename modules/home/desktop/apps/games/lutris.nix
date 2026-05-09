{ osConfig, ... }:

{
  programs.lutris = {
    enable = false;
    steamPackage = osConfig.programs.steam.package;
  };
}
