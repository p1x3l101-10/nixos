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
  # Turn off unixAuth to rely on the smartcard (for services that dont play nice with it)
  security.pam.services = (builtins.listToAttrs (map
    (name: { inherit name; value = { unixAuth = false; }; })
    [
      "polkit-1"
    ]
  ));
  services.pcscd = {
    enable = true;
  };
  hardware.gpgSmartcards.enable = true;
}
