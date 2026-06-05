{ osConfig, ... }:

{
  programs.lutris = {
    enable = true;
    steamPackage = osConfig.programs.steam.package;
  };
}
