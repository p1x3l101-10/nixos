{ pkgs, ... }:

{
  services.yubikey-agent.enable = true;
  programs.yubikey-manager.enable = true;
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
  /*
  services.udev.extraRules = ''
    ACTION=="remove",\
      ENV{HID_ID}=="0003:00001050:00000407",\
      ENV{HID_NAME}=="Yubico YubiKey OTP+FIDO+CCID",\
      RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  '';
  */
}
