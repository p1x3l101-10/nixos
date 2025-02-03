{ pkgs ? import <nixpkgs> { }
, inputs ? { }
, lib ? pkgs.lib
, mkShell ? pkgs.mkShell
, gnupg ? pkgs.gnupg
, sops ? pkgs.sops
, system ? pkgs.system
, ssh-to-pgp ? pkgs.ssh-to-pgp
}:
let
  sopsPkgs =
    if (inputs == { }) then
      (import <sops-nix> { inherit pkgs; }) # Legacy support
    else
      (inputs.sops-nix.packages.${system}) # Normal flake things
  ;
  GPGHome = "./.git/gnupg"; # Use impure git dir that gets regen'd on new shell
  sshKey = "/nix/host/keys/ssh/rsa.key";
in

mkShell {
  packages = [
    gnupg
    sops
    ssh-to-pgp
  ];

  nativeBuildInputs = with sopsPkgs; [
    sops-init-gpg-key
    sops-import-keys-hook
  ];
  # Note: you must use nix-shell for this
  sopsPGPKeyDirs = [
    "./modules/nixos/base/secrets/keys/hosts"
    "./modules/nixos/base/secrets/keys/users"
  ];
  sopsCreateGPGHome = true;
  sopsGPGHome = GPGHome;
  shellHook = ''
    echo "Input password to import ssh key for secret management"
    echo "It will be cleared on shell exit"
    sudo cat ${sshKey} | ${ssh-to-pgp}/bin/ssh-to-pgp -private-key | ${gnupg}/bin/gpg --import
    trap "rm -rfv ${GPGHome}" EXIT
  '';
}
