{ ... }:

{
  boot = {
    plymouth = {
      enable = false;
    };
    #consoleLogLevel = 0;
    consoleLogLevel = 4;
    initrd.verbose = true;
    kernelParams = [
      #"quiet"
      #"splash"
      "boot.shell_on_fail"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    loader.timeout = 0;
  };
}
