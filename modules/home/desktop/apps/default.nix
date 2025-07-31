{ lib, ... }:

{
  imports = (
    #(lib.internal.confTemplates.importList ./programs) ++ 
    (lib.internal.confTemplates.importList ./games)
  );
}
