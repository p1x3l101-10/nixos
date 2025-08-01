pkgs: lib:
lib.fix (self: {
  modiferKey = "SUPER";
  terminal = "kitty";
  fileManager = "dolphin";
  spotlight = "wofi --show drun";
  appLauncher = self.spotlight;
  clipboardMenu = "cliphist-wofi-img | wl-copy";
  updates = {
    updater = "kitty \"sudo nixos-rebuild boot\"";
  };
  clockFormat = "%_I:%M:%S %P %a %b %e %Y";
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
