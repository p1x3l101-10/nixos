{ osConfig, ... }:

{
  imports = [
    ./apps
  ];
  home = {
    stateVersion = osConfig.system.stateVersion;
  };
}
