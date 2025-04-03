{ inputs, lib, ... }:

{
  # Trust noone, not even yourself
  nix.settings = {
    #substitute = false;
    #substituters = lib.mkForce [];
    #extra-substituters = lib.mkForce [];
    keep-outputs = true;
    keep-derivations = true;
  };
}