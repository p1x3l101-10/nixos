{ pkgs, lib, inputs }:

import ./systems/nixbook/systemd-sysupdate.nix { inherit pkgs lib; inherit (inputs) self; }