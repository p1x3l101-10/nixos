{ ... }:

{
  imports = [
    ./instances/magical-meat.nix
    ./bluemap-nginx.nix
    ./svc.nix
    #./gtnh.nix
  ];
  networking.sshForwarding.ports = [
    25565
    24454
  ];
}
