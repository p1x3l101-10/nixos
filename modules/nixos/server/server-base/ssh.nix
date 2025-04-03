{ lib, ... }:

{
  services.openssh = {
    settings.PermitRootLogin = lib.mkForce "yes";
  };
}
