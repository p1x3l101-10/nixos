{ ... }:

{
  imports = [
    ./module.nix
  ];
  networking.sshForwarding = {
    enable = true;
    trustedHostKeys = [
      "[srv01.exsmachina.org]:2222 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBDu8VS/AEY5smqFoxM+hRKoCp5cTofBcNKhgyni1qk4A5XKTPpn5YTpbGRMPx5Xsl4xp3Q5y/gs3Y+j+qvzE+A0="
    ];
    sshPort = 2222;
    keyFile = "/nix/host/keys/ssh-tunnel/id.key";
  };
}
