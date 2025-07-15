{ globals, ... }:

{
  services.mastodon = {
    enable = globals.server.dns.exists;
    localDomain = "mastodon.${globals.server.dns.basename}";
    extraConfig.SINGLE_USER_MODE = "true";
    streamingProcesses = 3;
    webPort = 3023;
    smtp.fromAddress = "noreply@mastodon.${globals.server.dns.basename}";
  };
  environment.persistence."/nix/host/state/Servers/Mastodon".directories = [
    { directory = "/var/lib/mastodon"; user = "mastodon"; group = "mastodon"; }
    { directory = "/var/lib/redis-mastodon"; user = "redis-mastodon"; group = "redis-mastodon"; }
  ];
}
