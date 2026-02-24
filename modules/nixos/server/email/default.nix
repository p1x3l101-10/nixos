{ ext, globals, config, pkgs, ... }:

{
  mailserver.stateVersion = 3;
  imports = [
    ext.inputs.nixos-mailserver.nixosModules.mailserver
    ./dkim.nix
    ./server.nix
    ./ssl.nix
  ];
  environment.persistence."/nix/host/state/Servers/EMail".directories = with config.mailserver; [
    "/var/spool/mail"
    mailDirectory
    sieveDirectory
    dkimKeyDirectory
    backup.snapshotRoot
  ];
}
