{ globals, ... }:

{
  services.mastodon = {
    enable = globals.server.dns.exists;
    localDomain = "mastodon.${globals.server.dns.basename}";
    extraConfig.SINGLE_USER_MODE = "true";
    streamingProcesses = 3;
    smtp.fromAddress = "noreply@mastodon.${globals.server.dns.basename}";
  };
  environment.persistence."/nix/host/state/Servers/Mastodon".directories = [
    "/var/lib/mastodon"
  ];
}