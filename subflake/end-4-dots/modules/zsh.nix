{ config, lib, ... }:
let
  enabled = config.illogical-impulse.enable &&
   config.programs.zsh.enable;
in
{
  config = lib.mkIf enabled {
    programs.zsh.initExtra = ''
      # Use the generated color scheme

      if test -f ~/.cache/ags/user/generated/terminal/sequences.txt; then
          cat ~/.cache/ags/user/generated/terminal/sequences.txt
      fi
    '';
  };
}