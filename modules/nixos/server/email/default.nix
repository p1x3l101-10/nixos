{ globals, config, lib, ... }:

let
  host = config.networking.domain;
  domain = "mail.${config.networking.domain}";
  inherit (globals.dirs) keys state;
in {
  services.opensmtpd = {
    enable = true;
    setSendmail = true;
    serverConfiguration = ''
      filter check_dyndns phase connect match rdns regex { '.*\.dyn\..*', '.*\.dsl\..*' } disconnect "550 no residential connections"
      filter check_rdns phase connect match !rdns disconnect "550 no rDNS is so 80s"
      filter check_fcrdns phase connect match !fcrdns disconnect "550 no FCrDNS is so 80s"
      filter senderscore proc-exec "filter-senderscore -blockBelow 10 -junkBelow 70 -slowFactor 5000"
      filter rspamd proc-exec "filter-rspamd"

      table aliases file:/etc/mail/aliases

      listen on 0.0.0.0 tls pki ${domain} filter { check_dyndns, check_rdns, check_fcrdns, senderscore, rspamd }
      listen on 0.0.0.0 port submission tls-require pki ${domain} auth filter rspamd

      action "local_mail" maildir junk alias <aliases>
      action "outbound" relay helo ${domain}

      match from any for domain "${host}" action "local_mail"
      match for local action "local_mail"

      match from any auth for any action "outbound"
      match for any action "outbound"
    '';
  };
  environment.etc."mail/aliases".text = "";
  environment.persistence."${state}/Servers/EMail".directories = [
    "/var/spool/opensmtpd"
  ];
  networking.sshForwarding.ports = (lib.optionals globals.server.dns.exists [
    { host = 25; remote = 2555; }
    { host = 143; remote = 1430; }
    { host = 587; remote = 5870; }
    { host = 993; remote = 9930; }
  ]);
  imports = [
    ./acme.nix
    ./autoconfig.nix
    ./rspamd.nix
  ];
}
