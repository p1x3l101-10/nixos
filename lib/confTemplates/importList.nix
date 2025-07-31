{ lib, ext, self }:

src:

let
  files = builtins.readDir src;
  nixFiles = lib.attrsets.filterAttrs (_: type: type == "regular") files;
  nixFileNames = lib.attrsets.filterAttrs (name: _: lib.strings.hasSuffix ".nix" name) nixFiles;
  importRaw = lib.attrsets.mapAttrsToList (fileName: _: (src + "/${fileName}")) nixFileNames;
in

lib.lists.remove (src + "/default.nix") importRaw
