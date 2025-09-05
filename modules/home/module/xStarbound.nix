{ ext, ... }:

{
  imports = [
    (import ./support/xStarbound.nix ext.inputs.xStarbound)
  ];
}
