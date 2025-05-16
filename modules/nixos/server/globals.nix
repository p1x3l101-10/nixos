{ lib }:

lib.fix (self: {
  server = {
    dns = { # DNS data and helpers
      basename = "piplup.pp.ua"; # Basename for dns
      exists = (if self.server.basename != "" then true else false); # True when dns is not empty, otherwise false
      required = attrs: (lib.mkIf self.server.dns.exists attrs); # mkIf wrapper to check if the dns is set or not
      requiredList = list: (lib.optionals self.server.dns.exists list) # Optionals wrapper to do the same but for lists
    };
  };
  vps = {
    ip = "";
    dns = self.server.dns.basename;
    valid = self.server.dns.exists;
    get = (
      if self.vps.valid then
        self.vps.dns
      else
        self.vps.ip
    );
  };
})