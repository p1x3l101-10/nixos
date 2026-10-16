{ lib, ext, self }:

infusions:

lib.mapAttrs (
  (
    { name
    , value
    }:
    (final: prev: self.infusion.infuse prev value)
  )
  infusions
)
