{ lib, globals, ... }:

{
  security.acme = globals.server.dns.required {
    acceptTerms = true;
    defaults.email = "scott.blatt.0b10@gmail.com";
  };
}