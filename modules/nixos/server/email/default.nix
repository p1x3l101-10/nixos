{ ext, globals, config, pkgs, ... }:

let
  mkMailDir = directory: { inherit directory; user = "virtualMail"; group = "virtualMail"; mode = "0770"; };
in {
  mailserver.stateVersion = 3;
  imports = [
    ext.inputs.nixos-mailserver.nixosModules.mailserver
    ./dkim.nix
    ./mailProxy.nix
    ./server.nix
    ./ssl.nix
  ];
  environment.persistence."/nix/host/state/Servers/EMail".directories = with config.mailserver; [
    { directory = "/var/spool/mail"; mode = "1777"; }
    (mkMailDir mailDirectory)
    (mkMailDir sieveDirectory)
    { directory = dkimKeyDirectory; user = "rspamd"; group = "rspamd"; mode = "0755"; }
    backup.snapshotRoot
  ];
}
