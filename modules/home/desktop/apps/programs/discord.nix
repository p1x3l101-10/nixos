{ pkgs, ... }:

{
  programs.vesktop = {
    enable = true;
    package = pkgs.vesktop.overrideAttrs (oldAttrs: {
      desktopItems = [
        ((builtins.elemAt oldAttrs.desktopItems 0).override {
          exec = "vesktop --ozone-platform-hint=auto %U";
        })
      ];
    });
    vencord = {
      useSystem = true;
    };
  };
}
