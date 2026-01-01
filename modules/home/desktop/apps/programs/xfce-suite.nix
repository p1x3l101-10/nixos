{ lib, pkgs, ... }:

{
  programs = {
    thunar = {
      enable = true;
      thumbnails = true;
      config = {
        actions = [
          {
            icon = "utilities-terminal";
            name = "Open Terminal Here";
            unique-id = "1754173888245658-1";
            command = "exo-open --working-directory %f --launch TerminalEmulator";
            description = "Example for a custom action";
            patterns = [ "*" ];
            startup-notify = true;
            directories = true;
          }
        ];
      };
    };
    xarchiver = {
      enable = true;
    };
  };
  gtk.gtk3.bookmarks = (map
    (x: "file:///home/pixel/${x}")
    [
      "Camera"
      "Documents"
      "Downloads"
      "Games"
      "Music"
      "Oculus"
      "Phone\\ Misc"
      "Pictures"
      "Programs"
      "Sync"
      "Templates"
      "Videos"
    ]
  );
  xdg.configFile."Thunar/uca.xml".force = true;
  home.packages = with pkgs.xfce; [
    pkgs.xarchiver
    xfmpc
  ];
}
