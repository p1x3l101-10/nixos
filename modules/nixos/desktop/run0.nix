{ pkgs, ... }:

{
  security.run0 = {
    enableSudoAlias = false; # Done by myself
  };
  security.sudo.enable = false;
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "sudo";
      text = ''
        if [[ "$1" == -* ]]; then
          echo "This script is a sudo-alias to systemd's run0 and does not support any sudo parameters."
          exit 1
        fi
        exec run0 "$@"
      '';
    })
  ];
}
