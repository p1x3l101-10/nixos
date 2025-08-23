{ ext, ... }:

{
  home.packages = [
    ext.inputs.nyarchAssistant.packages.${ext.system}.newelle
  ];
}
