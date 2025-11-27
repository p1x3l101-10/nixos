{ ... }:

let
  rcon_port = 25575;
in {
  services.minecraft.settings.extraPorts = [
    rcon_port
  ];
  networking.sshForwarding.ports = [
    rcon_port
  ];
}
