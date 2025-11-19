{ ... }:

let
  svc_port = 24454;
in
{
  services.minecraft.settings.extraPorts = [
    { to = svc_port; protocol = "udp"; }
  ];
  networking.sshForwarding.ports = [
    svc_port
  ];
}
