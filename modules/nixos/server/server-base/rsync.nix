{ pkgs, ... }:

{
  users.users.rsync = {
    isNormalUser = true;
    home = "/var/lib/rsync";
    autoSubUidGidRange = false;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKlmhvzQ1zV76AiZUt13OoFV5vyL6xlFkSfUh1IbNBue sblatt@SS-Mac-sblatt.local"
    ];
    packages = with pkgs; [
      rsync
    ];
  };
  services.openssh.settings.AllowUsers = [ "rsync" ];
  environment.persistence."/nix/host/state/Servers/RSync".directories = [
    { directory = "/var/lib/rsync"; user = "rsync"; mode = "0700"; }
  ];
  # Chrooted dir for security
  systemd.tmpfiles.settings."10-ssh-chroot" = {
    "/var/lib/ssh-chroot/rsync/var/lib/rsync".d = {
      user = "rsync";
      group = "users";
      mode = "0755";
    };
    "/var/lib/ssh-chroot/rsync/nix/store".d = {
      user = "root";
      group = "root";
      mode = "0755";
    };
    # This needs access to binaries
    # Use booted system to ensure gc roots
    # NOTE: I could probably do this better with only pkgs.rsync, but im lazy like that lol
    "/var/lib/ssh-chroot/rsync/run/current-system".C.argument = "/run/booted-system";
  };
  # Bind mount nix store for shells and stuff
  fileSystems."/var/lib/ssh-chroot/rsync/nix/store" = {
    device = "/nix/store";
    options = [ "bind" "ro" ];
  };
  # Needed dirs
  fileSystems."/var/lib/ssh-chroot/rsync/lib/rsync" = {
    device = "/var/lib/rsync";
    options = [ "bind" "rw" ];
  };
  fileSystems."/var/lib/ssh-chroot/rsync/etc" = {
    device = "/etc";
    options = [ "bind" "ro" ];
  };
  services.openssh.extraConfig = ''
    Match User rsync
      ChrootDirectory /var/lib/ssh-chroot/rsync
  '';
}
