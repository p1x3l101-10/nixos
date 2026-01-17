{ ... }:

{
  programs.btop = {
    enable = true;
    settings = {
      update_ms = 1000;
    };
  };
  xdg.configFile."btop/btop.conf".force = true;
}
