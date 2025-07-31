{ lib, ... }:

{
  nix.settings = lib.internal.attrsets.mergeAttrs [
    {
      substituters = [ "https://unmojang.cachix.org" ];
      trusted-public-keys = [ "unmojang.cachix.org-1:OfHnbBNduZ6Smx9oNbLFbYyvOWSoxb2uPcnXPj4EDQY=" ];
    }
    {
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    }
  ];
}
