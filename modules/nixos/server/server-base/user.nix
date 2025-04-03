{ pkgs, ... }:
{
  users.users.pixel = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7hEnkX2r9nnIoVUa+isMwtdEppqWMTU9VDVE47ftLb MacBook"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9YD5mX4qfWS35Kcrk2hymaXlcSEUs3lWYa9bLKOcNW Pixels-PC"
    ];
    extraGroups = [ "wheel" ];
    initialHashedPassword = "$y$j9T$NSMuZ83C3iGB1HqRhcZOy.$6CGZk2KH94gE/gjBro9vioOkOFJw.a4rhQKJI4HzBB9";
    packages = with pkgs; [
      borgbackup
      vim
    ];
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7hEnkX2r9nnIoVUa+isMwtdEppqWMTU9VDVE47ftLb MacBook"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9YD5mX4qfWS35Kcrk2hymaXlcSEUs3lWYa9bLKOcNW Pixels-PC"
  ];
  users.mutableUsers = false;
  services.openssh.settings.AllowUsers = [ "pixel" "root" ];
  environment.etc.nixos.source = "/home/pixel/nix-server";
  environment.persistence."/nix/host/state/UserData".users.pixel.directories = [
    ".ssh"
    "nix-server"
    "dump"
  ];
  programs.git.config = {
    user = {
      name = "Pixel";
      email = "scott.blatt.0b10@gmail.com";
    };
    init.defaultBranch = "main";
  };
  systemd.tmpfiles.settings."10-sudo-lectures"."/var/db/sudo/lectured/1000".f = {
    user = "root";
    group = "root";
    mode = "-";
  };
}
