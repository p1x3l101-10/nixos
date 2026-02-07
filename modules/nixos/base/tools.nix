{ pkgs, ext, ... }:

let
  inherit (ext) inputs system;
in {
  environment.systemPackages = with pkgs; [
    inputs.nixos-cli.packages."${system}".nixos-cli
  ];
}
