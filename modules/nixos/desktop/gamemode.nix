{ ... }:

{
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10;
        desiredgov = "performance";
        desiredprof = "performance";
        softrealtime = "auto";
        inhibit_screensaver = 1;
        disable_splitlock = 1;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility"; # Can damage hardware, be sure to monitor for any iffy usage
        gpu_device = 0;
        amd_performance_level = "high";
      };
      cpu = {
        amd_x3d_mode_desired = "frequency";
      };
    };
  };
  # Set user-specific needs for gamemode use
  users.users.pixel.extraGroups = [ "gamemode" ];
}
