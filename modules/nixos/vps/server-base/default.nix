{ ... }:

{
  imports = [
    ./container.nix
    ../../server/server-base/ip-block.nix
    ./network.nix
    ./nix.nix
    #./proxy.nix
    ./speed.nix
    ./ssh.nix
    ./user.nix
  ];
}
