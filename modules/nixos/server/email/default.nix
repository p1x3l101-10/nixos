{ pkgs, globals, ... }:

let
  email = username: "${username}@${globals.server.dns.basename}";
in {
  mailserver = {
    enable = globals.server.dns.exists;
    fqdn = "mail.${globals.server.dns.basename}";
    domains = [ globals.server.dns.basename ];
    loginAccounts = {
      "${email "pixel"}" = {
        hashedPasswordFile = ./passwd/pixel;
      };
    };
  };
}