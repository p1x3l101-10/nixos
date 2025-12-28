{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "wivrn-dashboard-keepawake";
      runtimeInputs = with pkgs; [
        systemd
        wivrn
      ];
      text = ''
        exec systemd-inhibit --what=idle:sleep --mode=block --who="WiVRn" --why="WiVRn server needs screen to stay on" wivrn-dashboard
      '';
    })
  ];
}
