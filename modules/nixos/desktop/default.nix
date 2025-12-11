{ lib, ... }:
{
  _module.args = {
    globals = {
      type = "desktop";
    };
  };
  imports = [
    ./desktop
  ] ++ (lib.internal.confTemplates.importList ./.);
}
