
{ lib, ... }:

{
  imports = (lib.internal.confTemplates.importList ./.);
}
