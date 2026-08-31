{ lib, ext, self }:

f: x:

# Throws an error if the function fails once
# Otherwise it simply returns the input list

builtins.addErrorContext "While ensuring a list has valid contents" (
  if (lib.lists.all f x) then (
    x
  ) else (
    builtins.throw "Filter function returned false on list"
  )
)
