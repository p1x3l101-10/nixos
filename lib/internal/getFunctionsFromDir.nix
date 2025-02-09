{ lib, ext }:
callLib:

dir:

let
  files = builtins.readDir dir;
  nixFiles = lib.attrsets.filterAttrs (_: type: type == "regular") files;
  nixFileNames = lib.attrsets.filterAttrs (name: _: lib.strings.hasSuffix ".nix" name) nixFiles;
in

lib.attrsets.mapAttrs' (
  fileName: _: {
    name = lib.strings.removeSuffix ".nix" fileName;
    value =  callLib (dir + "/${fileName}");  # Wrap in function to call with args
  }
) nixFileNames
