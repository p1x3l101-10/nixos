{ config, ... }:
{
  # WINS
  services.samba = {
    nsswins = true;
    enableNmbd = true;
  };
  services.cntlm.netbios_hostname = config.networking.hostName;
}
