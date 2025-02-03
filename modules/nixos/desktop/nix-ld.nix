{ pkgs, inputs, ... }:
{
  programs.nix-ld = {
    enable = true;
    #libraries = [];
  };
  environment.systemPackages = [
    inputs.nix-autobahn.packages.x86_64-linux.nix-autobahn
  ];
}
