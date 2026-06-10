{ ext
, buildFHSEnv
, callPackage
, fetchSteam ? callPackage (ext.inputs.steam-fetcher.outPath + "/fetch-steam") {}
, dst-server-unwrapped ? callPackage ./package.nix { inherit ext fetchSteam; }
, steamworks-sdk-redist ? callPackage (ext.inputs.steam-fetcher.outPath + "/steamworks-sdk-redist") { inherit fetchSteam; }
, writeShellScript
}:

buildFHSEnv {
  inherit (dst-server-unwrapped) name meta;
  
  runScript = writeShellScript "dst-server-runner.sh" ''
    export SteamAppId=322330                                                         
    export SteamGameId=322330

    exec ${dst-server-unwrapped}/bin64/dontstarve_dedicated_server_nullrenderer_x64 "$@"
  '';

  targetPkgs = pkgs: [
    dst-server-unwrapped
    steamworks-sdk-redist
  ];
}
