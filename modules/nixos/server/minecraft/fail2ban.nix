{ lib, ... }:

{
  services.fail2ban.jails.minecraft = {
    settings = {
      filter = "minecraft-whitelist";
      logpath = "/var/lib/minecraft/data/logs/latest.log";
      maxretry = "3";
      bantime = "1h";
    };
  };
  # Custom filter
  environment.etc."fail2ban/filter.d/minecraft.conf".text = lib.generators.toINI {} {
    Definition = {
      failregex = ''
        ^.*com\.mojang\.authlib\.GameProfile\@\.\+\[.*name\=<USER>.*\] \(\/<ADDR>\:[0-9]*\) lost connection\: You are not whitelisted on this server\!.*$
        ^.*\[minecraft/ServerLoginPacketListenerImpl\]\: <USER> \(\/<ADDR>\:[0-9]*\) lost connection\: Disconnected.*$
      '';
      ignoreregex = "";
    };
  };
}
