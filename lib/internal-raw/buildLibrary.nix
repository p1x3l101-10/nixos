{ lib, ext, self }:
getFunctionsFromDir:

src: dirs:

lib.attrsets.foldlAttrs
  (
    acc: dirName: _: acc // { ${dirName} = getFunctionsFromDir (src + "/${dirName}"); }
  )
{ }
  (
    builtins.listToAttrs (
      map
        (
          dir: {
            name = dir;
            value = null;
          }
        )
        dirs
    )
  )
