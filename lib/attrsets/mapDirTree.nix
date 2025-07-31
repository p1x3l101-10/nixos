{ lib, ext, self }:

path:

let
  out = (lib.fix (self: {
    mapDirTree = basePath: path:
      let
        entries = builtins.readDir path;

        result = lib.attrsets.mapAttrs
          (name: type:
            let
              fullPath = "${path}/${name}";
            in
            if type == "directory" then
              (self.mapDirTree basePath fullPath) // {
                _path = fullPath;
              }
            else if type == "regular" then
              fullPath
            else
              throw "Unsupported file type: ${type} at ${fullPath}"
          )
          entries;
      in
      result // { _path = path; };
  }));
in
out.mapDirTree path path
