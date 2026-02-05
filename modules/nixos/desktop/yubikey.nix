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
  services.udev.extraRules = ''
    ACTION=="remove",\
      ENV{SUBSYSTEM}=="usb",\
      ENV{PRODUCT}=="1050/407/574",\
      RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  '';
}
