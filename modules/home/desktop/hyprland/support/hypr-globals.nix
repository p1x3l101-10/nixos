pkgs: lib:
lib.fix (self: {
  modiferKey = "SUPER";
  apps = lib.hypr.processDesktop {
    terminal = "kitty";
    fileManager = "thunar";
    web = "zen-twilight";
    documentViewer = "okular";
    imageViewer = "feh";
    videoPlayer = "mpv";
    textEditor = "nvim";
    discord = "Vesktop";
    steam = "steam";
    roblox = "org.vinegarhq.Sober";
    archiveManager = "xarchiver";
  };
  #lockCmd = "loginctl lock-session";
  lockCmd = "noctalia-shell ipc call lockScreen lock";
  spotlight = "noctalia-shell ipc call launcher toggle";
  appLauncher = self.spotlight;
  clipboardMenu = "noctalia-shell ipc call launcher clipboard";
  updates = {
    updater = "kitty \"sudo nixos-rebuild boot\"";
  };
  clockFormat = {
    date = "%a, %d %b";
    time = "%I:%M:%S %P";
    long = self.clockFormat.date + ", " + self.clockFormat.time;
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
