{ ext
, callPackage
, umu-launcher
, proton-ge-bin
, coreutils-full
, protonPath ? proton-ge-bin.steamcompattool
, votv-unwrapped ? callPackage ./unwrapped.nix { inherit protonPath; }
}:

let
  nuLibs = callPackage ./libs.nix {};
  info = builtins.fromJSON (builtins.readFile ./info.json);
  inherit (ext.inputs.nix-gaming.packages.${ext.system}) wine-discord-ipc-bridge;
in

nuLibs.mkNuScript {
  name = "voicesofthevoid";
  version = info.download.version;

  packageDir = ./.;
  packageDirFilter = (file: (!file.hasExt "nix") || (!file.hasExt "json"));

  extraBuildInputs = [
    votv-unwrapped
  ];

  binaryPath = [
    umu-launcher
    coreutils-full
    wine-discord-ipc-bridge
  ];

  preProcessInstallCommands = ''
    sed -i 's+@@VOTV_UNWRAPPED_PKG@@+${votv-unwrapped}+g' $out/bin/voicesofthevoid
    sed -i 's+@@PROTON_PATH@@+${protonPath}+g' $out/bin/voicesofthevoid
    sed -i 's+@@UMU_STORE@@+${info.umu.store}+g' $out/bin/voicesofthevoid
    sed -i 's+@@UMU_GAMEID@@+${info.umu.gameId}+g' $out/bin/voicesofthevoid
  '';

  extraInstallCommands = ''
    ln -s "${votv-unwrapped}/share" $out/share
  '';

  passthru.unwrappedBase = callPackage ./unwrapped.nix { inherit protonPath; };

  meta = {
    inherit (votv-unwrapped.meta) description homepage;
  };
}
