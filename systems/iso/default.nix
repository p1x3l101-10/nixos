{ pkgs, ext, ... }:

let
  inherit (ext) inputs system;
  inherit (inputs.self.nixosModules) base;
in {
  imports = [
    # Upstream ISO
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    # Only pull the base parts we actually need
    "${base}/cachix.nix"
    "${base}/locale.nix"
  ];
  # Seperate it from the upstream ISO
  networking.hostName = "pixels-nixos-iso";
  networking.hostId = "adf379c2";
  environment.etc.machine-id.text = "adf379c23feb4fa381f1fc7b137de815";
  # Packages used during install
  environment.systemPackages = with pkgs; [
    fido2luks
    rsync
    disko
  ];
  # Fav shell
  environment.shells = [ pkgs.nushell ];
  users.users = {
    nixos.shell = pkgs.nushell;
    root.shell = pkgs.nushell;
  };
  # New CLI for nixos
  services.nixos-cli = {
    enable = true;
  };
  # Flake stuff
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    package = pkgs.nixVersions.latest;
  };
  programs.git = {
    enable = true;
    package = pkgs.gitMinimal;
  };
}