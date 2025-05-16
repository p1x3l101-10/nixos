{ lib }:

lib.fix (self: {
  server = {
    dns = { # DNS data and helpers
      basename = "piplup.pp.ua"; # Basename for dns
      exists = (if self.server.dns.basename != "" then true else false); # True when dns is not empty, otherwise false
      required = attrs: (lib.mkIf self.server.dns.exists attrs); # mkIf wrapper to check if the dns is set or not
    };
    www.exists = true
  };
  vps = {
    enabled = true;
    ip = "";
    dns = self.server.dns.basename;
    validDomain = (if self.vps.dns != "" then true else false);
    get = (
      if self.vps.validDomain then
        self.vps.dns
      else
        self.vps.ip
    );
  };
})