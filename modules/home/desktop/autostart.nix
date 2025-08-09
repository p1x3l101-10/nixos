{ config, osConfig, pkgs, ... }:

{
  xdg.autostart = {
    enable = true;
    readOnly = true;
    entries = [
      ((builtins.toString (osConfig.programs.steam.package.override {
        steam-unwrapped = pkgs.steam-unwrapped.overrideAttrs (old: {
          postInstall = old.postInstall + ''
            cp $out/share/applications/steam.desktop $out/share/applications/steam-autostart.desktop
            sed -i '/[Desktop Entry]/a \
            NoDisplay=true/' $out/share/applications/steam-autostart.desktop
            sed -i 's/Exec=steam %U/Exec=steam -silent %U' $out/share/applications/steam-autostart.desktop
          '';
        });
      })) + "/share/applications/steam-autostart.desktop")
      ((builtins.toString ((builtins.elemAt config.vesktop.package.desktopItems 0).override {
        exec = "vesktop --start-minimized %U";
      })) + "/share/applications/vesktop.desktop")
    ];
  };
}
