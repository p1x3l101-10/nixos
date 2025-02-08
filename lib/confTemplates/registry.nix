{ lib, ... }:

inputs: lib.attrsets.mapAttrs' (
  name: value: lib.attrsets.nameValuePair
    name ({ flake = inputs.${name}; })
) inputs

/*
used for generating registries
{ inputs, lib, ... }:
{
  nix.settings.registry = lib.internal.confTemplates.registry inputs;
}

turns into this
{
  nix.settings.registry = {
    self.flake = inputs.self;
    nixpkgs.flake = inputs.nixpkgs;
    ...
  };
}
*/