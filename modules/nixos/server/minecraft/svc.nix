{ ... }:

let
  svc_port = 24454;
in
{
  services.minecraft.settings.extraPorts = [
    svc_port
  ];
  networking.sshForwarding.ports = [
    svc_port
  ];
}
