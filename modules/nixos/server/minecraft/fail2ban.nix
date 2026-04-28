{ lib, ... }:

{
  services.fail2ban.jails = {
    minecraft-whitelist = {
      settings = {
        filter = "minecraft-whitelist";
        logpath = "/var/lib/minecraft/data/logs/latest.log";
        maxretry = "1"; # They will tell me if they are not whitelisted, so only allow one chance to prevent possible exploits
        bantime = "1h";
      };
    };
    minecraft-connection-spam = {
      settings = {
        filter = "minecraft-connection-spam";
        logpath = "/var/lib/minecraft/data/logs/latest.log";
        maxretry = "3"; # Allow for people with terrible internet to join
        bantime = "1h";
      };
    };
  };
  # Custom filter
  environment.etc."fail2ban/filter.d/minecraft-whitelist.conf".text = lib.generators.toINI {} {
    Definition = {
      failregex = builtins.concatStringsSep "\n          " [
        ''^.*com.mojang.authlib.GameProfile@.+\[.*id\=<F-UUID>.*name\=<USER>.*\] \(\/<ADDR>\:[0-9]*\) lost connection\: You are not whitelisted on this server\!.*$''
        ''^.*com.mojang.authlib.GameProfile@.+\[.*name\=<USER>.*id\=<F-UUID>.*\] \(\/<ADDR>\:[0-9]*\) lost connection\: You are not whitelisted on this server\!.*$''
        ''^.*<USER> lost connection: You are not whitelisted on this server\!.*$''
      ];
      ignoreregex = "";
    };
  };
  environment.etc."fail2ban/filter.d/minecraft-connection-spam.conf".text = lib.generators.toINI {} {
    Definition = {
      failregex = ''
        ^.*\[minecraft/ServerLoginPacketListenerImpl\]\: <USER> \(\/<ADDR>\:[0-9]*\) lost connection\: Disconnected.*$
      '';
      ignoreregex = "";
    };
  };
}
