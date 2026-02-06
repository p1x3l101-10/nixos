{ pkgs, ... }:

{
  services.yubikey-agent.enable = true;
  home.packages = with pkgs; [
    yubikey-personalization
    age-plugin-yubikey
    yubico-piv-tool
    yubioath-flutter
  ];
}
