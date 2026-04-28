{ lib, ext, self }:

value:

if (builtins.isBool value) then (
  if (value) then "true" else "false"
) else (
  builtins.toString value
)
