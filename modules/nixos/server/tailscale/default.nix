{ ... }:

{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    authKeyFile = "/var/lib/tailscale/authKey";
  };
  environment.persistence."/nix/host/state/Servers/Tailscale".directories = [
    "/var/lib/tailscale"
  ];
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}