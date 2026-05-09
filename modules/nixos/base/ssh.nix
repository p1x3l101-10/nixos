{ pkgs, ... }:
{
  # Needed for decryption keys
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = true;
      AuthenticationMethods = "publickey";
    };
    hostKeys = [
      {
        bits = 4096;
        path = "/nix/host/keys/ssh/rsa.key";
        type = "rsa";
      }
    ];
    allowSFTP = true;
    openFirewall = true;
  };
  # Fix terminfo errors on all systems
  environment.systemPackages = with pkgs; [
    kitty.terminfo
  ];
}
