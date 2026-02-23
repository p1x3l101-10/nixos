{ config, lib, ... }:

let
  domain = "mail.${config.networking.domain}";
  inherit (config.security.acme) certs;
  ssl = let
    inherit (certs."${domain}") directory;
  in {
    key = "${directory}/key.pem";
    cert = "${directory}/cert.pem";
  };
in {
  services.nginx.virtualHosts."${domain}" = {
    enableACME = true;
    globalRedirect = config.networking.domain;
  };
  services.opensmtpd.serverConfiguration = ''
    pki ${domain} cert "/var/lib/smtpd/cert.pem"
    pki ${domain} key "/var/lib/smtpd/key.pem"
  '';
  systemd = {
    tmpfiles.settings."50-smtpd"."/var/lib/smtpd".d = {
      user = "root";
      group = "root";
      mode = "0700";
    };
    paths = {
      copy-smtpd-keys = {
        # Wait for acme to alter the keys
        requiredBy = [ "acme-renew-${domain}.timer" "opensmtpd.service" ];
        before = [ "opensmtpd.service" ];
        pathConfig.PathModified = [
          ssl.key
          ssl.cert
        ];
      };
    };
    services = {
      copy-smtpd-keys = {
        # Need tempdir
        requires = [ "systemd-tmpfiles-setup.service" ];
        after = [ "systemd-tmpfiles-setup.service" ];
        # Force opensmtpd to restart when the keys change
        before = [ "opensmtpd.service" ];
        requiredBy = [ "opensmtpd.service" ];
        partOf = [ "opensmtpd.service" ];
        script = ''
          rm -f /var/lib/smtpd/key.pem /var/lib/smtpd/cert.pem
          cp ${ssl.key} /var/lib/smtpd/key.pem
          chown root:root /var/lib/smtpd/key.pem
          cp ${ssl.cert} /var/lib/smtpd/cert.pem
          chown root:root /var/lib/smtpd/cert.pem
        '';
      };
    };
  };
}
