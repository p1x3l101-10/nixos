{ options, globals, ... }:

{
  services.rspamd = {
    enable = true;
    locals."dkim_signing.conf".text = ''
      selector = "default";
      domain = "project-insanity.org";
      path = "/var/lib/maddy/dkim_keys/$domain_$selector.key";
    '';
  };
  systemd.services.rspamd.serviceConfig.SupplementaryGroups = [ "smtpd" ];
  environment.persistence."${globals.dirs.state}/Servers/EMail".directories = [
    "/var/lib/rspamd"
  ];
}
