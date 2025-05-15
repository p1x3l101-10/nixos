{ ... }:

{
  systemd.services.sshd.serviceConfig.After = [
    "network.target"
  ];
}