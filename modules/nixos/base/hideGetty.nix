{ ... }:

{
  systemd.maskedServices = (builtins.genList (i:
    "getty@tty${toString (i + 1)}"
  ) 5);
  systemd.services."getty@tty6".enable = true; # Ensure tty6 exists
}