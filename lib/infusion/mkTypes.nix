{ lib, ext, self }:

let
  yants = self.infusion.yants "infusion.mkTypes";
  inherit (yants) defun;
in

# The input function has it's argument set as the newly generated yants
# TODO: Figure out how to make it more similar to lib.fixedPoints.fix

builtins.addErrorContext "while generating an overlayed type with yants" (
  defun (with yants; [ string function (attrs any) ]) (name: typeGenerator:
    let
      newYants = self.infusion.yants name;
    in
    newYants // (typeGenerator newYants)
  )
)
