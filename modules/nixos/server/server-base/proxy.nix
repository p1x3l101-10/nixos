{ pkgs, lib, userdata, ... }:

{
  users.users.proxy = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = userdata [ "proxyKey" ] [
      "scott"
      #"cayden"
      #"kenton"
      #"spradley"
      #"daniel"
      #"david"
    ];
    shell = pkgs.shadow;
    home = "/var/empty";
    autoSubUidGidRange = false;
  };
  services.openssh.settings.AllowUsers = [ "proxy" ];
  services.openssh.extraConfig = ''
    Match User proxy
      ForceCommand nologin
  '';
}
