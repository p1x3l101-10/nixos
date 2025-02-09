{ lib, ext }:

cases: default:

(
  lib.lists.findFirst (lib.builtins.getAttr "case") {} cases
).out or default