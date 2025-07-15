{ globals, pkgs, config, lib, ... }:

{
  services.nginx = {
    virtualHosts."mastodon.${globals.server.dns.basename}" = globals.server.dns.required {
      root = "${config.services.mastodon.package}/public/";
      forceSSL = true;
      enableACME = true;
      locations = {
        "/".tryFiles = "$uri @proxy";
        "@proxy".proxyPass = "http://unix:/run/mastodon-web/web.socket";
        "/system/".alias = "/var/lib/mastodon/public-system/";
        "/api/v1/streaming/" = {
          proxyPass = "http://mastodon-streaming";
          proxyWebsockets = true;
        };
      };
    };
    upstreams = {
      mastodon-streaming = {
        extraConfig = ''
          least_conn;
        '';
        servers = builtins.listToAttrs (
          map
            (i: {
              name = "unix:/run/mastodon-streaming/streaming-${toString i}.socket";
              value = { };
            })
            (lib.range 1 config.services.mastodon.streamingProcesses)
        );
      };
    };
  };
  users.groups.${config.services.mastodon.group}.members = [ config.services.nginx.user ];
}
