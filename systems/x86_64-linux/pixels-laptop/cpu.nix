{ lib, ... }:
{
  /* Make builds the same again
  nixpkgs.system = lib.mkForce {
    features = [ "gccarch-skylake" ];
    system = "x86_64-linux";
    gcc = {
      arch = "skylake";
      tune = "skylake";
    };
  };
  */
}
