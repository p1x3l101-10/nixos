{ config, ... }:
{
  # WINS
  services.samba = {
    nsswins = true;
    nmbd.enable = true;
  };
  services.cntlm.netbios_hostname = config.networking.hostName;
}
