{ globals, config, lib, ... }:

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
  networking.sshForwarding.ports = (lib.optionals globals.server.dns.exists [
    { host = 25; remote = 2555; }
    { host = 143; remote = 1430; }
    { host = 587; remote = 5870; }
  ]);
  imports = [
    ./mta-sts.nix
    ./rspamd.nix
    ./tls.nix
  ];
}
