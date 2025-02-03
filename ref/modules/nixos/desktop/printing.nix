{ pkgs, ... }:
{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  services.printing = {
    browsing = true;
    defaultShared = true;
    openFirewall = true;
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
    ];
  };
}
