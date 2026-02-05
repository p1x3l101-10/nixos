{ ... }:

{
  services.yubikey-agent.enable = true;
  programs.yubikey-manager.enable = true;
  programs.yubikey-touch-detector = {
    enable = true;
    libnotify = true;
  };
  security.pam.u2f = {
    enable = true;
    control = "sufficient";
    settings = {
      userpresence = 1;
      cue = true;
    };
  };
  services.pcscd = {
    enable = true;
  };
  hardware.gpgSmartcards.enable = true;
}
