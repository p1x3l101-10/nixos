{ config, ext, pkgs, ... }:

{
  programs.rsi-launcher = {
    enable = (config.networking.hostName == "pixels-pc");
    patchXwayland = true;
    launchCommand = "%command%";
    gamescope = {
      enable = true;
      args = [
        "-W" "1980" "-H" "1080"
        "--force-grab-cursor"
      ];
    };
    location = "$XDG_DATA_HOME/star-citizen";
    setLimits = true;
    enforceWaylandDrv = true;
    enableNTsync = true;
    umu.enable = true;
    preCommands = ''
      export PROTON_ENABLE_WAYLAND=1
      export WAYLANDDRV_PRIMARY_MONITOR="DP-1"
    '';
  };
  services.nixos-cli.prebuildOptionCache = false; # FIXME: Upstream for rsi has bugged default options and this cannot gracefully handle that
  nixpkgs.overlays = [
    ext.inputs.nix-citizen.overlays.default
  ];
  environment.systemPackages = with pkgs; [
    lug-helper
  ];
  system.allowedUnfree.packages = [
    "rsi-launcher"
    "rsi-installer"
  ];
}
