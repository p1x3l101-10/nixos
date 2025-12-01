{ ... }:

{
  imports = [
    ./instances/botany.nix
    ./bluemap-nginx.nix
    ./svc.nix
    ./rcon.nix
    #./gtnh.nix
  ];
  networking.sshForwarding.ports = [
    25565
    24454
  ];
}
