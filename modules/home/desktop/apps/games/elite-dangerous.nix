{ pkgs, ... }:

{
  home.packages = with pkgs; [
    min-ed-launcher
    ed-odyssey-materials-helper
    edmarketconnector
  ];
}
