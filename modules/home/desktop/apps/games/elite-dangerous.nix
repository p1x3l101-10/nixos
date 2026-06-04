{ pkgs, ... }:

{
  home.packages = with pkgs; [
    min-ed-launcher
    edhm-ui
    ed-odyssey-materials-helper
    edmarketconnector
  ];
  home.allowedUnfree.packages = [
    "edhm-ui"
  ];
}
