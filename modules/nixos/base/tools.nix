{ pkgs, ... }:

{
  services.nixos-cli = {
    enable = true;
    useActivationInterface = true;
  };
  environment.systemPackages = with pkgs; [
    optnix
  ];
}
