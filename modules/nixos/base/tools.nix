{ pkgs, ... }:

{
  services.nixos-cli = {
    enable = true;
    useActivationInterface = true;
  };
  environment.systemPackages = with pkgs; [
    optnix
    nix-fast-build
    nix-output-monitor
    nix-eval-jobs
  ];
}
