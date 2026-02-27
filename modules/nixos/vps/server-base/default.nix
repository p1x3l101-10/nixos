{ ... }:

{
  imports = [
    ./container.nix
    ../../server/server-base/ip-block.nix
    ./nix.nix
    #./proxy.nix
    ./speed.nix
    ./ssh.nix
    ./user.nix
  ];
}
