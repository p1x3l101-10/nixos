{ ... }:
{
  xdg.configFile."evince/print-settings".text = ''
    [Print Settings]
    duplex=horizontal
    printer=Brother_MFC_J6935DW
    cups-Duplex=DuplexNoTumble
  '';
  xdg.configFile."evince/print-settings".force = true;
}
