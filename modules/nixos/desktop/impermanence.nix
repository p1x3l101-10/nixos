{ ... }:
{
  environment.persistence."/nix/host/state".directories = [
    "/var/lib/upower"
    "/var/lib/logmein-hamachi"
    "/home"
  ];
}
