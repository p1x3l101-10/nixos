{ config, lib, eLib, ... }:

let
  mkGmail = otherAttrs: (eLib.attrsets.mergeAttrs [{
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
  }
    otherAttrs]);
  standardEmail = otherAttrs: (eLib.attrsets.mergeAttrs [{
    maildir.path = otherAttrs.userName;
    thunderbird = {
      enable = true;
      profiles = [ ];
      settings = id: (eLib.attrsets.compressAttrs "." { });
      messageFilters = [ ];
    };
  }
    otherAttrs]);
in
{
  accounts = {
    email = {
      maildirBasePath = "${config.xdg.dataHome}/mail";
      certificatesFile = "/etc/ssl/certs/ca-certificates.crt";
      accounts = {
        exsmachina = {
          primary = true;
          userName = "pixel@exsmachina.org";
          realName = "Pixel";
          address = "pixel@exsmachina.org";
          signature = {
            showSignature = "none";
            text = "";
          };
          imap = {
            authentication = "plain";
            host = "srv01.exsmachina.org";
            port = 993;
            tls = {
              enable = true;
              useStartTls = false;
            };
          };
          smtp = {
            authentication = "plain";
            host = "srv01.exsmachina.org";
            port = 465;
            tls = {
              enable = true;
              useStartTls = false;
            };
          };
          folders = {
            drafts = "Drafts";
            inbox = "Inbox";
            sent= "Sent";
            trash = "Trash";
          };
          gpg = {
            key = "ACD0910C3FD1322FCE8F73A63C2D22F9DE687571";
            signByDefault = true;
            encryptByDefault = false;
          };
          thunderbird = {
            enable = true;
            profiles = [ ];
            messageFilters = [ ];
            settings = id: (eLib.attrsets.compressAttrs "." {});
          };
          passwordCommand = "keepassxc-cli show -y 1 --no-password /home/pixel/Sync/Keepass/keepass.kdbx Logins/ExsMachina -a Password";
        };
      };
    };
  };
  programs = {
    mbsync.enable = true;
    msmtp.enable = true;
  };
  services.mbsync.enable = true;
}
