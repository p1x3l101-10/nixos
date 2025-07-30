{ lib, ext, self }:

cases: default:

(
  lib.lists.findFirst (builtins.getAttr "case") { } cases
).out or default
