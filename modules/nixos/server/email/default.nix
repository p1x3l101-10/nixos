{ ext, globals, config, pkgs, ... }:

{
  mailserver.stateVersion = 3;
  imports = [
    ext.inputs.nixos-mailserver.nixosModules.mailserver
    ./dkim.nix
    ./server.nix
    ./ssl.nix
  ];
}
