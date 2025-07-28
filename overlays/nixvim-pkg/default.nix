{ inputs, ... }:

final: prev: {
  nixvim = inputs.nixvim-config.packages.${prev.system}.default;
}