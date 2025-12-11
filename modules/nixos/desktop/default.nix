{ lib, ... }:
{
  _module.args = {
    globals = {
      type = "desktop";
    };
  };
  imports = [
    ./desktop
    ./games
  ] ++ (lib.internal.confTemplates.importList ./.);
}
