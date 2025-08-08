{ config, lib, ... }:

let
  mkGmail = otherAttrs: (lib.internal.attrsets.mergeAttrs [{
    lieer = {
      enable = true;
      settings = {
        drop_non_existing_label = true;
      };
    };
    userName = otherAttrs.address;
    imap = {
      host = "imap.gmail.com";
      port = 993;
      tls.enable = true;
    };
    smtp = {
      host = "smtp.gmail.com";
      port = 587;
      tls.enable = true;
    };
    msmtp = {
      enable = true;
      extraConfig = {
        auth = "plain";
      };
    };
    mbsync = {
      enable = true;
      create = "both";
      expunge = "maildir";
    };
    passwordCommand = "cat /nix/host/keys/mail/gmail/${otherAttrs.address}";
  } otherAttrs]);
  standardEmail = otherAttrs: (lib.internal.attrsets.mergeAttrs [{
    maildir.path = otherAttrs.userName;
    thunderbird = {
      enable = true;
      profiles = [];
      settings = id: (lib.internal.attrsets.compressAttrs "." {});
      messageFilters = [];
    };
  } otherAttrs]);
in {
  accounts = {
    email = {
      maildirBasePath = "${config.xdg.dataHome}/mail";
      certificatesFile = "/etc/ssl/certs/ca-certificates.crt";
      accounts = {
        personal-google = standardEmail (mkGmail {
          primary = true;
          address = "scott.blatt.0b10@gmail.com";
          realName = "Pixel";
        });
      };
    };
  };
  programs = {
    mbsync.enable = true;
    msmtp.enable = true;
  };
  home.file.".thunderbird/default/logins.json" = {
    force = true;
    text = builtins.toJSON {
      nextId = 2;
      logins = [(rec {
        id = 1;
        hostname = "https://imap.gmail.com";
        httpRealm = hostname;
        formSubmitUrl = null;
        usernameField = "";
        passwordField = "";
        encryptedUsername = "MEoEEPgAAAAAAAAAAAAAAAAAAAEwFAYIKoZIhvcNAwcECHETn+3BXUAVBCAiNMa8VZjnbrECQBfjlikEolXwC6wU0/vecqV+ggh50g==";
        encryptedPassword = "MEIEEPgAAAAAAAAAAAAAAAAAAAEwFAYIKoZIhvcNAwcECA82cuX7bLIWBBhcIoCXDuJNAn0N8Pl82Zhr4ifrz1Xnue4=";
        guid = "{a8bd4dda-26d9-4bc5-8b85-8c25a8ef6a25}";
        encType = 1;
        timeCreated = 1754672084132;
        timeLastUsed = 1754672084132;
        timePasswordChanged = 1754672084132;
        timesUsed = 1;
        syncCounter = 1;
        everSynced = false;
        encryptedUnknownFields = "MDIEEPgAAAAAAAAAAAAAAAAAAAEwFAYIKoZIhvcNAwcECNaUsLNk+/5VBAhVMGOuScbpcQ==";
      })];
      potentiallyVulnerablePasswords = [];
      dismissedBreachAlertsByLoginGUID = {};
      version = 3;
    };
  };
  systemd.user.tmpfiles.rules = [
    "L /home/pixel/.thunderbird/default/key4.db - - - - /nix/host/keys/mail/key4.db"
  ];
  services.mbsync.enable = true;
}
