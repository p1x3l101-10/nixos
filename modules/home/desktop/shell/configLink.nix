{ osConfig, ... }:

{
  systemd.user.tmpfiles.rules = [
    "L /home/pixel/.config/quickshell - - - - ${osConfig.environment.etc."nixos".source}/modules/home/desktop/shell/config"
  ];
}
