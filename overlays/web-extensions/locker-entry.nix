{ pkgs ? import <nixpkgs> { } }:

pkgs.callPackage ./extensions-locker.pkg.nix { }
