{ lib, ... }:

{
  # Ensure this config fragment is at the end of all the integrations so I can tweak them
  programs.nushell.extraConfig = lib.modules.mkAfter (builtins.readFile ./config-final.nu);
}
