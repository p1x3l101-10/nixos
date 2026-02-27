{ globals, lib, ... }:

{
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    ignoreIP = [
      # Local subnets
      "10.0.0.0/8" "172.16.0.0/12" "192.168.0.0/16"
    ];
    bantime = "24h"; # Ban for one day on the first fail
    bantime-increment = {
      enable = true;
      multipliers = "1 2 4 8 16 32 64";
      maxtime = "168h"; # Do not ban for more than 1 week
      overalljails = true; # Calculate the bantime based on all the violations
    };
    jails = {
      dovecot = {
        settings = {
          # block IPs which failed to log-in
          # aggressive mode add blocking for aborted connections
          filter = "dovecot[mode=aggressive]";
          maxretry = 3;
        };
      };
    };
  };
  # Make punishments persist over reboot
  environment.persistence."/nix/host/state/Fail2Ban".directories = [
    "/var/lib/fail2ban"
  ];
  # For manual ip bans
  networking.firewall.extraCommands = builtins.concatStringsSep "\n" [
    (builtins.concatStringsSep "\n" (map (ip: "iptables -I nixos-fw -s ${ip} -j DROP") globals.badips.v4))
    (builtins.concatStringsSep "\n" (map (ip: "iptables -I nixos-fw -s ${ip} -j DROP") globals.badips.v6))
  ];
}
