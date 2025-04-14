{ pkgs, lib, ... }:

let
  base = ../../modules/nixos/base;
in
{
  imports = [
    "${base}/cachix.nix"
    "${base}/locale.nix"
    "${base}/ssh.nix"
  ];
  # Bootloader
  services.fwupd.enable = true;
  boot = {
    loader = {
      timeout = lib.mkDefault 0;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
      systemd-boot = {
        enable = false;
        editor = false;
        edk2-uefi-shell.enable = true;
      };
    };
    lanzaboote = {
      enable = true;
      configurationLimit = 2;
    };
    initrd.systemd.enable = true;
    uki.tries = 1;
  };

  environment.binsh = "${pkgs.dash}/bin/dash";
  networking.networkmanager.enable = true;
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    llmnr = "true";
    dnsovertls = "true";
  };
  users = {
    defaultUserShell = pkgs.bashInteractive;
    users.root.shell = pkgs.bashInteractive;
  };
  programs.nano.enable = lib.mkDefault false;
  system.stateVersion = "24.11";
}