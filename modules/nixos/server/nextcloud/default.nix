{ globals, ... }:

{
  imports = (globals.server.dns.requiredList [
    ./nextcloud.nix
    ./nginx.nix
  ]);
}