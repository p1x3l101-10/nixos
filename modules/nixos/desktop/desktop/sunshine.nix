{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    sunshine
  ];
  security.wrappers.sunshine = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_admin+p";
    source = "${pkgs.sunshine}/bin/sunshine";
  };
  networking.firewall = {
    allowedTCPPortRanges = [{ from = 47984; to = 48010; }];
    allowedUDPPortRanges = [{ from = 47998; to = 48010; }];
  };
  systemd.user.services.sunshine = {
    description = "Sunshine self-hosted game stream host for Moonlight";
    startLimitBurst = 5;
    startLimitIntervalSec = 500;
    serviceConfig = {
      ExecStart = "${config.security.wrapperDir}/sunshine";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}