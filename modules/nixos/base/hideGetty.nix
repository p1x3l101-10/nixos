{ ... }:

{
  systemd.services = builtins.listToAttrs (builtins.genList (i:
    {
      name = "getty@tty${toString (i + 1)}";
      value.enable = false;
    }
  ) 6);
}