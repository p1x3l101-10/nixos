{ ... }:

{
  imports = [
    ./spellbound-skies.nix
    #./bluemap-nginx.nix
    #./gtnh.nix
  ];
  networking.sshForwarding.ports = [
    25565
  ];
}