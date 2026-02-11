{ globals, config, ... }:

let
  host = config.networking.domain;
  inherit (globals.dirs) keys state;
in {
  services.maddy = {
    enable = globals.server.dns.exists;
    primaryDomain = host;
    openFirewall = true;
    ensureAccounts = [
      "postmaster@${host}"
      "pixel@${host}"
    ];
    ensureCredentials = {
      "postmaster@${host}".passwordFile = "${keys}/email/login/postmaster";
      "pixel@${host}".passwordFile = "${keys}/email/login/pixel";
    };
  };
  environment.persistence."${state}/Servers/EMail".directories = [
    "/var/lib/maddy"
  ];
  imports = [
    ./mta-sts.nix
    ./rspamd.nix
    ./tls.nix
  ];
}
