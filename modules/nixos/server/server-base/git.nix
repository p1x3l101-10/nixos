{ pkgs, lib, userdata, ... }:

{
  users.users.git = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = userdata [ "sshKeys" ] [
      "scott"
    ];
    shell = pkgs.shadow;
    home = "/var/lib/git";
    autoSubUidGidRange = false;
  };
  services.openssh.settings.AllowUsers = [ "git" ];
  services.openssh.extraConfig = ''
    Match User proxy
      ForceCommand git-shell
  '';
  environment.persistence."/nix/host/state/Servers/Git".directories = [
    { directory = "/var/lib/git"; user = "git"; group = "users"; mode = "0755"; }
  ];
}
