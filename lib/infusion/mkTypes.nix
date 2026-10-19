{ lib, ext, self }:

let
  yants = self.infusion.yants "infusion.mkTypes";
  inherit (yants) defunc;
in

# The input function has it's argument set as the newly generated yants
# TODO: Figure out how to make it more similar to lib.fixedPoints.fix

builtins.addErrorContext "While generating an overlayed type with yants" (
  defunc (with yants; [ string (functionWithArgs (attrs any)) (attrs any) ]) (name: typeGenerator:
    let
      newYants = self.infusion.yants name;
    in
    self.infusion.infuse newYants (typeGenerator newYants)
  )
)
