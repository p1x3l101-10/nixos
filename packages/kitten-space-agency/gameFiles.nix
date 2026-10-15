{ info
, stdenvNoCC
, callPackage
, refreshToken
, ksaTarball ? callPackage ./ksaTarball.nix { inherit info refreshToken; }
}:

stdenvNoCC.mkDerivation {
  inherit (info) name version;

  src = ksaTarball;

  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/lib/ksa
    tar xzf $src -C $out/lib/ksa --strip-components=1
    chmod +x $out/lib/ksa/KSA $out/lib/ksa/Brutal.Monitor.Subprocess
  '';

  meta = {
    inherit (info.meta) description homepage;
    platforms = [ "x86_64-linux" ];
  };
}
