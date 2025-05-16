{ lib }:

lib.fix (self: {
  server = {
    dns = { # DNS data and helpers
      basename = "piplup.pp.ua"; # Basename for dns
      exists = (if self.basename != "" then true else false); # True when dns is not empty, otherwise false
      required = conditional: (lib.mkIf self.dns.exists conditional); # mkIf wrapper to check if the dns is set or not
    };
  };
})