{ ext, ... }:

{
  imports = [
    ./instances/techrpg.nix
    #./fail2ban.nix
    #./bluemap-nginx.nix
    #./svc.nix
    #./rcon.nix
  ];
  networking.sshForwarding.ports = [
    25565
    24454
  ];
  environment.systemPackages = [
    ext.selfPkgs.minecraft-helper
  ];
}
