{ options, globals, ... }:

{
  services.maddy.config = ''
    msgpipeline local_routing {
      check {
        rspamd {
          api_path http://localhost:11334
        }
      }
  '' +
  # Defaults
  ''
      destination postmaster $(local_domains) {
        modify {
          replace_rcpt &local_rewrites
        }
        deliver_to &local_mailboxes
      }
      default_destination {
        reject 550 5.1.1 "User doesn't exist"
      }
    }
  '';
  services.rspamd = {
    enable = true;
    locals."dkim_signing.conf".text = ''
      selector = "default";
      domain = "project-insanity.org";
      path = "/var/lib/maddy/dkim_keys/$domain_$selector.key";
    '';
  };
  systemd.services.rspamd.serviceConfig.SupplementaryGroups = [ "maddy" ];
  environment.persistence."${globals.dirs.state}/Servers/EMail".directories = [
    "/var/lib/rspamd"
  ];
}
