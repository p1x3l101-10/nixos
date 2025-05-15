{ ... }:

{
  systemd.services.sshd.serviceConfig.After = [
    "network.target"
    "99-wg0.network"
  ];
}