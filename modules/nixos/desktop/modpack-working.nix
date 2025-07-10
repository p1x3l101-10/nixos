{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    packwiz
    signify
  ];
}