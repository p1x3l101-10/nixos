{ ... }:

{
  services.yubikey-agent.enable = true;
  programs.yubikey-manager.enable = true;
  programs.yubikey-touch-detector = {
    enable = true;
    libnotify = true;
  };
  security.pam = {
    yubico = {
      enable = true;
      mode = "challenge-response";
      control = "sufficient";
    };
  };
}
