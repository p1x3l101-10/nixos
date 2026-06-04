{ lib, ext, self }:

base': exponent':

let
  pow' = base: exponent: if (exponent == 0) then (
    1
  ) else (
    base * (pow' base exponent)
  );
in

pow' base' exponent'
