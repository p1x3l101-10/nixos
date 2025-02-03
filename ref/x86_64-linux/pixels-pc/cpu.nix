{ lib, ... }:
{
  nixpkgs.system = lib.mkForce {
    features = [ "gccarch-znver3" ];
    system = "x86_64-linux";
    gcc = {
      arch = "znver3";
      tune = "znver3";
    };
  };
}
