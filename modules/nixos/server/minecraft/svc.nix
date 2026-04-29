{ ... }:

let
  svc_port = 24454;
in
{
  services.minecraft.settings.extraPorts = [
    { to = svc_port; protocol = "udp"; }
  ];
  networking.firewall.allowedUDPPorts = [ 24454 ];
  networking.sshForwarding.ports = [
    svc_port
  ];
}
