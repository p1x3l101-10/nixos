{ pkgs, ... }:

{
  imports = [ ./nftables-redirections.nix ];
  users.users.proxy = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAMABQWe3ZUXM/76DQYxWUuRs7bZM3c6aI2n79yG2wEG root@pixels-server"
    ];
    shell = pkgs.shadow;
    home = "/var/empty";
    autoSubUidGidRange = false;
  };
  services.openssh.settings.AllowUsers = [ "proxy" ];
  services.openssh.extraConfig = ''
    Match User proxy
      ForceCommand nologin
  '';
  # Firewall rules to make services work again
  networking = {
    nftables.portRedirections = [
      {
        sourcePort = 80;
        sinkPort = 8080;
      }
      {
        sourcePort = 443;
        sinkPort = 4443;
      }
    ];
    firewall.allowedTCPPorts = [
    ];
  };
}
