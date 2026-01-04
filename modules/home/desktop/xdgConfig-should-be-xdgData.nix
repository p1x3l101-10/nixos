{ config, ... }:

{
  systemd.user.tmpfiles.rules = (map
    (x: "L ${config.xdg.configHome}/${x} - - - - ${config.xdg.dataHome}/${x}")
    [ # Convert this list into a link from .config to .local/share
      "steamtinkerlaunch"
      "r2modmanPlus-local"
      "vesktop/sessionData"
      "r2modman"
      "unity3d"
      "SideQuest"
      "tetrio-desktop"
      "VRCX"
      "unityhub"
      "Blockbench"
      "blender"
    ]
  );
}
