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
  security.pam.services = {
    # Fixes for things that default to password
    polkit-1.allowNullPassword = true;
  };
  services.pcscd = {
    enable = true;
  };
  hardware.gpgSmartcards.enable = true;
}
