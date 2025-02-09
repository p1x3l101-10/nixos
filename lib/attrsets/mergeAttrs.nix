{ lib, ext }:

attrList:

let f = attrPath:
  lib.attrsets.zipAttrsWith (n: values:
    if lib.builtins.tail values == []
      then lib.builtins.head values
    else if all lib.builtins.isList values
      then lib.lists.unique (lib.builtins.concatLists values)
    else if all lib.builtins.isAttrs values
      then f (attrPath ++ [n]) values
    else last values
  );
in f [] attrList