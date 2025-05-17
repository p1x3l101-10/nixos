{ globals, pkgs, config, lib, ... }:

{
  services.nginx = {
    virtualHosts."mastodon.${globals.server.dns.basename}" = globals.server.dns.required {
      forceSSL = true;
      enableACME = true;
      locations = {
        "/" = {
          proxyPass = "http://mastodon-web";
          proxyWebsockets = true;
        };
        "/system/" = {
          root = "/var/lib/mastodon/public-system/";
          proxyWebsockets = true;
        };
        "/api/v1/streaming/" = {
          proxyPass = "http://mastodon-streaming";
          proxyWebsockets = true;
        };
      };
    };
    upstreams = {
      mastodon-web.servers = {
        "unix:/run/mastodon-web/web.socket" = {};
      };
      mastodon-streaming = {
        extraConfig = ''
          least_conn;
        '';
        servers = builtins.listToAttrs (
          map (i: {
            name = "unix:/run/mastodon-streaming/streaming-${toString i}.socket";
            value = { };
          }) (lib.range 1 config.services.mastodon.streamingProcesses)
        );
      };
    };
  };
  users.users.${config.services.nginx.user}.extraGroups = [
    "mastodon-web"
  ];
}