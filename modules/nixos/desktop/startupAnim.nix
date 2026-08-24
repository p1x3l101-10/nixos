{ ... }:

{
  boot = {
    plymouth = {
      enable = true;
      theme = "bgrt"; # NOTE: Stylix conflicts with this; if enabling stylix again, be sure to remove this option
    };
    consoleLogLevel = 0;
    kernelParams = [
      "quiet"
      "splash"
    ];
    loader.timeout = 0;
  };
  # Disable stylix because we want our own theme
  stylix.targets.plymouth.enable = false;
}
