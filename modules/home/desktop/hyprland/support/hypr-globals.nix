pkgs: lib:
let
  app = path: text: (builtins.toString pkgs.writeShellApplication { inherit text; name = "app"; runtimeInputs = path; });
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
})
