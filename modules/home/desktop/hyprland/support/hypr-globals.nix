pkgs: lib:
lib.fix (self: {
  modiferKey = "SUPER";
  apps = lib.hypr.processDesktop {
    terminal = "kitty";
    fileManager = "thunar";
    web = "zen-twilight";
    imageViewer = "feh";
    videoPlayer = "mpv";
    textEditor = "nvim";
  };
  spotlight = "wofi --show drun";
  appLauncher = self.spotlight;
  clipboardMenu = "cliphist-wofi-img | wl-copy";
  updates = {
    updater = "kitty \"sudo nixos-rebuild boot\"";
  };
  clockFormat = {
    date = "%a, %b %e %Y";
    time = "%I:%M:%S %P";
    long = self.clockFormat.date + " -- " + self.clockFormat.time;
  };
  notifications = {
    checker = builtins.toString (pkgs.writeShellScript "app" ''
      mako_mode=$(makoctl mode)
      if [[ "$mako_mode" == "default" ]]; then
        echo '${builtins.toJSON {
          text = "active";
          alt = "activated";
          class = "activated";
        }}'
      else
        echo '${builtins.toJSON {
          text = "muted";
          alt = "deactivated";
          class = "deactivated";
        }}'
      fi
    ''); 
    daemon = "mako";
  };
})
