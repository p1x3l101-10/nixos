{ ... }:

{
  imports = [
    ./borg.nix
    ./container.nix
    ./errorfixes.nix
    ./network.nix
    ./nix.nix
    ./proxy.nix
    ./rsync.nix
    ./speed.nix
    ./ssh.nix
    ./user.nix
  ];
}
