{ lib, ext, self }:

let
  procParameters = parameters: builtins.addErrorContext "While processing url parameters" (builtins.concatStringsSep "&"
    (map
      ({ name, value }: "${name}=${value}")
      (lib.attrsets.attrsToList parameters)
    )
  );
in builtins.addErrorContext "While defining the rest of a search URL" (
  { prefix
  , parameters ? {}
  , queryParam ? "q"
  , noQuery ? false
  }: builtins.concatStringsSep "" [
    prefix
    "?"
    (procParameters parameters)
    (if ((builtins.length (lib.attrsets.attrsToList parameters)) > 0) then "&" else "")
    (if noQuery then "" else "${queryParam}=")
  ]
)
