{ config, globals, options, ... }:

let
  inherit (globals.dirs) keys;
in {
  services.maddy = {
    tls = {
      loader = "acme";
      extraConfig = ''
        email scott.blatt.0b10@gmail.com
        agreed # I agree to Let's Encrypt's TOS
        host ${config.services.maddy.primaryDomain}
        challenge dns-01
        dns cloudflare {
          api_token "{env:CLOUDFLARE_DNS_API_KEY}"
        }
      '';
    };
    # Enable TLS listeners. Configuring this via the module is not yet
    # implemented, see https://github.com/NixOS/nixpkgs/pull/153372
    config = builtins.replaceStrings [
      "imap tcp://0.0.0.0:143"
      "submission tcp://0.0.0.0:587"
    ] [
      "imap tls://0.0.0.0:993 tcp://0.0.0.0:143"
      "submission tls://0.0.0.0:465 tcp://0.0.0.0:587"
    ] options.services.maddy.config.default;

    # Where to load the dns api token from
    secrets = [
      "${keys}/email/tls_tokens.env"
    ];
  };
  networking.firewall.allowedTCPPorts = [ 993 465 ];
}
