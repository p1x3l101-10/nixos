{ ext, ... }:

{
  home.packages = with ext.inputs.zen-browser.packages.${ext.system}; [
    default
  ];
}
