{ ... }@params:

{
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
    settings = import ./noctalia-settings.nix params;
  };
}
