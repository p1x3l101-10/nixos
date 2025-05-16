{ lib, globals, ... }:

{
  imports = [
    ./nginx.nix
  ] ++ lib.optionals globals.dns.exists [
    ./acme.nix
  ];
}