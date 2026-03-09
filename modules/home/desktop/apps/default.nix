{ eLib, ... }:

{
  imports = (
    (eLib.confTemplates.importList ./programs) ++
    (eLib.confTemplates.importList ./games)
  );
}
