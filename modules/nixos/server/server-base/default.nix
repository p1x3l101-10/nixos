{ ... }:

{
  imports = [
    ./borg.nix
    ./container.nix
    ./network.nix
    ./nix.nix
    ./proxy.nix
    ./rsync.nix
    ./speed.nix
    ./ssh.nix
    ./user.nix
  ];
}
