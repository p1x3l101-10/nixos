{ lib, ext, self }:

attrList:

let
  f = attrPath:
    lib.attrsets.zipAttrsWith (n: values:
      if builtins.tail values == [ ]
      then builtins.head values
      else if builtins.all builtins.isList values
      then lib.lists.unique (builtins.concatLists values)
      else if builtins.all builtins.isAttrs values
      then f (attrPath ++ [ n ]) values
      else lib.lists.last values
    );
in
f [ ] attrList
