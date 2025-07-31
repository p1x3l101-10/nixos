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

})
