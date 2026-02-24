{ ext, globals, config, pkgs, ... }:

let
  inherit (config.networking) domain;
in {
  mailserver = {
    enable = true;
    fqdn = "mail.${domain}";
    domains = [ domain ];
    loginAccounts = {
      "postmaster@${domain}" = {
        hashedPassword = "$y$j9T$xIqsbrS7kn13DWVH06nf11$ewQiB0.UkYcVSCIU5XqfuV9Ej4ss5.m1ATkks7YSU/9";
      };
      "pixel@${domain}" = {
        hashedPassword = "$y$j9T$ChefBxNe7LttV2jeKpeo00$DZJxTcIlROpaFyfUV109btSMI9khiDxDvugU/dUnLD3";
      };
    };
  };
}
