{ ... }:

{
  services.yubikey-agent.enable = true;
  programs.yubikey-manager.enable = true;
  services.pcscd = {
    enable = true;
  };
  hardware.gpgSmartcards.enable = true;
  services.u2f = {
    enable = true;
    users.pixel.keys = [
      # Primary Key
      ## Desktop
      {
        keyHandle = "jzTlDo4MglXnwCs6AMnkeIF8pbbiLMSyutf0urcWVyr3r3iY9h1LDx82wEy8CZZXRbxAtjobCaXJ+Tz/1+WhfA==";
        userKey = "V+nPm8JBW81UijvWR9tSTQbrOpkNtFIdFR+kSVKdm4XqBf//g5nlGYRfsTy12FieIoyN0c8RpuAPInBAJzwU/w==";
        coseType = "es256";
        options = "+presence";
      }
      ## Laptop
      {
        keyHandle = "E91mk3O5T07shOPsYUA9/c4KjxLVjRm1CbBvy4EpwwmukAdnt+0boMkQH1Kd0hiW/wwnimcYJfZ55Iok0L8haQ==";
        userKey = "Yrc/yrmO9pPiffZyRJnDkVSTGcXo662fibfqIIDD9tcZ6aTK/ivWbkyXhGPMBG4b76USXvGOQenR2TAg9Di0EQ==";
        coseType = "es256";
        options = "+presence";
      }
    ];
    pam = {
      control = "sufficient";
      settings = {
        userpresence = 1;
        cue = true;
      };
    };
    lockOnUnplug = false;
  };
  security.polkit.extraConfig = ''
    // Allow wheel group to restart pcscd without password
    // Needed because gpg signing with smartcards and pcscd conflict sometimes :(
    polkit.addRule(function(action, subject) {
      if (
        action.id == "org.freedesktop.systemd1.manage-units" &&
        action.lookup("unit") == "pcscd.service" &&
        subject.isInGroup("wheel")
      ) {
        return polkit.Result.YES;
      }
    });
  '';
}
