{ lib }:

lib.fix (self: {
  server = {
    dns = { # DNS data and helpers
      basename = "piplup.pp.ua"; # Basename for dns
      exists = (if self.basename != "" then true else false); # True when dns is not empty, otherwise false
      required = conditional: (lib.mkIf self.dns.exists conditional); # mkIf wrapper to check if the dns is set or not
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