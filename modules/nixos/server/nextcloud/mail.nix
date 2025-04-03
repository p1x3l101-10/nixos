{ ... }:

{
  services.nextcloud.settings = {
    mail_smtpmode = "sendmail";
    mail_sendmailmode = "pipe";
  };
}