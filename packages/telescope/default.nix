{ lib
, writeShellApplication
, stardust-xr-server
, callPackage
, init-script ? callPackage ./init.nix { }
}:

writeShellApplication {
  name = "telescope";
  runtimeInputs = [
    stardust-xr-server
  ];
  text = ''
    stardust-xr-server -o 1 -e "${init-script}/bin/init" "$@"
  '';
}