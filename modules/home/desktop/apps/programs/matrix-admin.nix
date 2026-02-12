{ pkgs, ... }:

{
  home.packages = with pkgs; [
    synapse-admin-etkecc
    synadm
  ];
}
