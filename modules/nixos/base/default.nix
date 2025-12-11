{ lib, inputs, ... }:
{
  imports = (lib.internal.confTemplates.importList ./.);
  nix.registry = lib.internal.confTemplates.registry inputs;
}
