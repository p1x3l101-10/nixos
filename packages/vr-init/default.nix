{ lib
, writeShellApplication
, stardust-xr-gravity
, stardust-xr-phobetor
, stardust-xr-magnetar
, stardust-xr-flatland
, stardust-xr-protostar
, stardust-xr-sphereland
, stardust-xr-atmosphere
, stardust-xr-kiara
, wayvr
}:

writeShellApplication {
  name = "init";
  runtimeInputs = [
    stardust-xr-gravity
    stardust-xr-phobetor
    stardust-xr-magnetar
    stardust-xr-flatland
    stardust-xr-protostar
    stardust-xr-sphereland
    stardust-xr-atmosphere
    stardust-xr-kiara
    wayvr
  ];
  text = ''
    unset LD_LIBRARY_PATH
    if [[ -v LD_LIBRARY_PATH_ORIGINAL ]]; then
      echo "Restored pre-exisiting LD_LIBRARY_PATH"
      export LD_LIBRARY_PATH="$LD_LIBRARY_PATH_ORIGINAL"
    fi

    xwayland-satellite :10 &
    export DISPLAY=:10 &
    sleep 0.5;

    wayvr &
    flatland &
    gravity -- 0 0.0 -0.5 hexagon_launcher &
    black-hole &
  '';
}
