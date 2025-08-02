{ ... }:

{
  services.preload.enable = true;
  environment.persistence."/nix/host/state/System".directories = [
    "/var/lib/preload"
  ];
}
