{ lib, ext, self }:

# Set `from` to either "modrinth" or "curseforge"
{ dataPack ? false
, modId
, slug ? null
, versionId
, partialFilename ? null
}@mod:
from:

let
  inherit (lib.lists) optional singleton;
  inherit (lib.strings) concatStringsSep;
in
(
  if (from == "modrinth") then
    concatStringsSep ":"
      (
        (optional dataPack "datapack")
        ++ singleton modId
        ++ (optional (versionId != null) versionId)
      )
  else # curseforge
    (if (slug != null) then slug else (builtins.toString modId))
      + (
      if (versionId != null) then ":${builtins.toString versionId}"
      else if (partialFilename != null) then "@${partialFilename}"
      else ""
    )
)
