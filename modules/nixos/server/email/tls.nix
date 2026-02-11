{ config, globals, options, ... }:

let
  inherit (globals.dirs) keys;
in {
  services.maddy = {
    tls = {
      loader = "acme";
      extraConfig = ''
        email scott.blatt.0b10@gmail.com
        agreed
        host ${config.services.maddy.primaryDomain}
        challenge dns-01
        dns cloudflare {
          api_token "{env:CLOUDFLARE_DNS_API_KEY}"
        }
      '';
    };
    # Enable TLS listeners. Configuring this via the module is not yet
    # implemented, see https://github.com/NixOS/nixpkgs/pull/153372
    config = ''
      imap tls://0.0.0.0:993 tcp://0.0.0.0:143 {
        auth &local_authdb
        storage &local_mailboxes
      }
      submission tls://0.0.0.0:465 tcp://0.0.0.0:587 {
        limits {
          all rate 50 1s
        }
        auth &local_authdb
        source $(local_domains) {
          check {
              authorize_sender {
                  prepare_email &local_rewrites
                  user_to_email identity
              }
          }
          destination postmaster $(local_domains) {
              deliver_to &local_routing
          }
          default_destination {
              modify {
                  dkim $(primary_domain) $(local_domains) default
              }
              deliver_to &remote_queue
          }
        }
        default_source {
          reject 501 5.1.8 "Non-local sender domain"
        }
      }
    '';
    # Where to load the dns api token from
    secrets = [
      "${keys}/email/tls_tokens.env"
    ];
  };
  networking.firewall.allowedTCPPorts = [ 993 465 ];
}
