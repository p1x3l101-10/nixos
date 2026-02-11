{ options, globals, ... }:

{
  services.maddy.config = builtins.replaceStrings ["msgpipeline local_routing {"] [''msgpipeline local_routing {
    check {
      rspamd {
        api_path http://localhost:11334
      }
    }
  ''] options.services.maddy.config.default;
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
