{ globals, ... }:

{
  imports = [
    ./nginx.nix
  ] ++ (globals.server.dns.requiredList [
    ./acme.nix
  ]);
}