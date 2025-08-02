{ lib, ext, self }:

pathSep': attrs':

let
  compressAttrs = (prefix: attrs: pathSep:
    lib.concatMapAttrs
      (k: v:
        if lib.types.attrs.check v then
          compressAttrs (prefix ++ [ k ]) v pathSep
        else
          { "${lib.strings.concatStringsSep pathSep (prefix ++ [k])}" = v; }
      )
      attrs
  );
in

compressAttrs [] attrs' pathSep'
