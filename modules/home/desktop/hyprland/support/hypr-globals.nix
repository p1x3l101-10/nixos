pkgs: lib: lib.fix(self: {
  modiferKey = "SUPER";
  terminal = (builtins.toString pkgs.writeShellApplication { name = "terminal"; runtimeInputs = with pkgs; [ kitty ]; text = ''
    kitty
  ''; });
  fileManager = (builtins.toString pkgs.writeShellApplication { name = "fileManager"; runtimeInputs = with pkgs; [ dolphin ]; text = ''
    dolphin
  ''; });
  spotlight = (builtins.toString pkgs.writeShellApplication { name = "spotlight"; runtimeInputs = with pkgs; [ wofi ]; text = ''
    wofi --show drun
  ''; });
  appLauncher = self.spotlight;
})
