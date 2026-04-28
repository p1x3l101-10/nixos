{ lib, ext, self }:

name: value: seperator:

if (value != [ ]) then (
  # Apply the effects of mkEnv to the list converted by mkEnvRawList
  (self.environment.mkEnv name (self.environment.mkEnvRawList name value seperator)."${name}")
) else (
  { }
)
