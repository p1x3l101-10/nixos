{ lib, ... }:

{
  systemd.services = builtins.listToAttrs (builtins.genList (i: {
    name = "getty@tty${toString (i + 1)}";
    value = {
      enable = lib.mkForce false;
      wantedBy = [];
      unitConfig = {
        ConditionPathExists = "/nonexistent"; # prevent any accidental activation
      };
    };
  }
  ) 5);
  systemd.services."getty@tty6".enable = true; # Ensure tty6 exists
}