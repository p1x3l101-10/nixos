{ pkgs, ... }:

{
  systemd.services.ssh-tunnel = {
    description = "Expose local ports on remote server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    restartIfChanged = true;
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 5;
      ExecStart = "${pkgs.openssh}/bin/ssh -NTC -vvv -i /nix/host/keys/ssh-tunnel/id.key -o StrictHostKeychecking=no -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -R 80:127.0.0.1:8080 -R 443:127.0.0.1:4443 -R 25565:127.0.0.1:25565 proxy@piplup.pp.ua";
    };
  };
}