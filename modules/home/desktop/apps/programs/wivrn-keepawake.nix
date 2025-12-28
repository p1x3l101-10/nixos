{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "wivrn-dashboard-keepawake" ''
      exec systemd-inhibit --what=idle:sleep --mode=block --who="WiVRn" --why="WiVRn server needs screen to stay on" wivrn-dashboard
    '')
  ];
}
