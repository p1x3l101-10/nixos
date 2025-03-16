{ ... }:
{
  environment.persistence."/nix/host/state/System".directories = [
    "/var/lib/upower"
  ];
  environment.persistence."/nix/host/state/Hamachi".directories = [
    "/var/lib/logmein-hamachi"
  ];
  environment.persistence."/nix/host/state/UserData".directories = [
    "/home"
  ];
}
