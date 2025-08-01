pkgs: lib:
let
  app = (path: text: (builtins.toString pkgs.writeShellApplication { inherit text; name = "app"; runtimeInputs = path; })) + "/bin/app";
in
lib.fix (self: {
  modiferKey = "SUPER";
  terminal = (app [ pkgs.kitty ] ''
    kitty
  '');
  fileManager = (app [ pkgs.dolphin ] ''
    dolphin
  '');
  spotlight = (app [ pkgs.wofi ] ''
    wofi --show drun
  '');
  appLauncher = self.spotlight;
  clipboardMenu = (app [ pkgs.cliphist pkgs.wofi pkgs.wl-clipboard ] ''
    cliphist-wofi-img | wl-copy
  '');
  updates = {
    updater = (app [ pkgs.nix pkgs.nixos-rebuild pkgs.kitty ] ''
      kitty "sudo nixos-rebuild boot"
    '');
  };
  clockFormat = "%I:%M:%S %P";
  notifications = {
    checker = (app [ pkgs.mako ] ''
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
