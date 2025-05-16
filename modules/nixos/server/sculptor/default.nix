{ globals, ... }:

{
  imports = (globals.server.dns.requiredList [
    ./nginx.nix
    ./sculptor.nix
  ]);
}