{ ... }:

{
  imports = [
    ./instances/aeronautics.nix
    #./bluemap-nginx.nix
    #./svc.nix
    #./rcon.nix
  ];
  networking.sshForwarding.ports = [
    25565
    24454
  ];
}
