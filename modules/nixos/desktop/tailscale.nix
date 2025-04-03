{ pkgs, lib, ... }:

{
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
}