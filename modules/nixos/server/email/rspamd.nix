{ options, globals, ... }:

{
  services.rspamd = {
    enable = true;
  };
  systemd.services.rspamd.serviceConfig.SupplementaryGroups = [ "smtpd" ];
  environment.persistence."${globals.dirs.state}/Servers/EMail".directories = [
    "/var/lib/rspamd"
  ];
}
