{ pkgs, inputs, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [ ];
  };
  environment.systemPackages = with pkgs; [
    inputs.nix-autobahn.packages.x86_64-linux.nix-autobahn
    nix-index
  ];
}
