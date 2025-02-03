{ ... }:
{
  imports = [
    ./autoUpgrade.nix
    ./base.nix
    ./bash.nix
    ./cachix.nix
    ./git.nix
    ./impermanence.nix
    ./locale.nix
    ./ssh.nix
    ./users-pixel.nix

    ./secrets/keys.nix
    ./secrets/passwords.nix
    ./secrets/wifi.nix
  ];
}
