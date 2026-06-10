{ ext
, lib
, stdenv
, callPackage
, fetchSteam ? callPackage (ext.inputs.steam-fetcher.outPath + "/fetch-steam") {}
}:

stdenv.mkDerivation (final: {
  name = "Don't Starve Together Dedicated Server";
  version = "2334955445349509271";

  src = fetchSteam {
    inherit (final) name;
    appId = "343050";
    depotId = "343052";
    manifestId = final.version;
    hash = "sha256-nF979ivww+GtV8KO3+CT0GQabw95J7uzVlkP2RlOaoc=";
  };

  # Skip phases that don't apply to prebuilt binaries.
  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mkdir -p $out/factory/data
    mkdir -p $out/factory/mods

    cp -r         \
      bin         \
      bin64       \
      data        \
      version.txt \
      $out

    chmod +x \
      $out/bin/dontstarve                                     \
      $out/bin/dontstarve_dedicated_server_nullrenderer       \
      $out/bin/scripts/launch_dedicated_server.sh             \
      $out/bin/scripts/launch_preconfigured_servers.sh        \
      $out/bin64/dontstarve                                   \
      $out/bin64/dontstarve_dedicated_server_nullrenderer_x64 \
      $out/bin64/scripts/launch_dedicated_server.sh           \
      $out/bin64/scripts/launch_preconfigured_servers.sh

    mv $out/data/unsafedata $out/factory/data/unsafedata
    ln -s /var/lib/dst-server/data/unsafedata $out/data/unsafedata

    cp -r mods $out/factory/mods
    ln -s /var/lib/dst-server/mods $out/mods

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://steamdb.info/app/${final.src.appId}/";
    changelog = "https://store.steampowered.com/news/app/${final.src.appId}?updates=true";
    sourceProvenance = with sourceTypes; [
      binaryNativeCode
    ];
    license = licenses.unfree;
    platforms = ["x86_64-linux"];
  };
})
