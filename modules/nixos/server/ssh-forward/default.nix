{ ... }:

{
  systemd.services.ssh-tunnel = {
    description = "Expose local ports on remote server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    restartIfChanged = true;
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 5;
      ExecStart = "/usr/bin/ssh -NTC -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -R 25575:127.0.0.1:25575 -R 443:127.0.0.1:443 -R 25565:127.0.0.1:25565 -R 22:127.0.0.1:2222 root@myNginxServer.au";
    };
  };
}