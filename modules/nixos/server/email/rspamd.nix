{ ... }:

{
  services.maddy.config = builtins.replaceStrings ["msgpipeline local_routing {"] [''msgpipeline local_routing {
    check {
      rspamd {
        api_path http://localhost:11334
      }
    }
  }''];
  services.rspamd = {
    enable = true;
    locals."dkim_signing.conf".text = ''
      selector = "default";
      domain = "project-insanity.org";
      path = "/var/lib/maddy/dkim_keys/$domain_$selector.key";
    '';
  };
  systemd.services.rspamd.serviceConfig.SupplementaryGroups = [ "maddy" ];
}
