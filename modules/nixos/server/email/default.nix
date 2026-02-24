{ ext, globals, config, pkgs, ... }:

{
  mailserver.stateVersion = 3;
  imports = [
    ext.inputs.nixos-mailserver.nixosModules.mailserver
    ./server.nix
    ./ssl.nix
  ];
}
