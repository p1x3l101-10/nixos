{ config, pkgs, ... }:

let
in {
  services.nginx.virtualHosts."${config.networking.domain}".locations."= /.well-known/mta-sts.txt".root = pkgs.writeText "mta-sts.txt" ''
    version: STSv1
    mode: enforce
    max_age: 604800
    mx: mx1.${config.networking.domain}'
  '';
}
