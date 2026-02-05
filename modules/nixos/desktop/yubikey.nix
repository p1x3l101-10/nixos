{ pkgs, ... }:

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
  services.udev.extraRules = ''
    ACTION=="unbind",\
      ENV{ID_VENDOR_FROM_DATABASE}=="Yubico.com",\
      ENV{ID_MODEL_FROM_DATABASE}=="Yubikey 4/5 OTP+U2F+CCID",\
      ENV{SUBSYSTEM}=="usb",\
      RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  '';
}
