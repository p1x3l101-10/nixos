{ ... }:

{
  boot = {
    plymouth = {
      enable = true;
    };
    consoleLogLevel = 0;
    kernelParams = [
      "quiet"
      "splash"
    ];
    loader.timeout = 0;
  };
}
