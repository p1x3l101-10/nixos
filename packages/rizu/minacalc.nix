{ lib
, stdenv
, fetchFromGitHub
, makePkgconfigItem
}:

let
  fs = lib.fileset;
  renameDrv = name: drv: stdenv.mkDerivation {
    inherit name;
    src = drv;
    installPhase = ''
      mkdir -p $out
      mv ./* $out
    '';
  };
in

stdenv.mkDerivation (self: {
  name = "minacalc-standalone";
  version = "ad2149deec4de9297991cc63a05e0ae50d7332e9";

  srcs = [
    (fetchFromGitHub {
      owner = "kangalio";
      repo = "minacalc-standalone";
      rev = self.version;
      hash = "sha256-yv7lhUyfsIPcOQD18Nh9at19iRv91mVQtECz5pGAlqs=";
    })
    (makePkgconfigItem {
      name = "minacalc";
      url = self.meta.homepage;
      version = self.version;
      libs = [
        "-L${builtins.placeholder "out"}/lib" "-lminacalc"
      ];
      cflags = [
        "-I${builtins.placeholder "dev"}/include"
      ];
    })
    (renameDrv "makefile" (fs.toSource {
      root = ./.;
      fileset = fs.unions [
        ./support/minacalc/Makefile
      ];
    }))
  ];
  sourceRoot = "source";

  outputs = [ "out" "dev" ];

  buildPhase = ''
    cp ../minacalc.pc/lib/pkgconfig/minacalc.pc .
    cp ../makefile/support/minacalc/Makefile .
    make PFX=$out DEVPFX=$dev
  '';

  installPhase = ''
    make PFX=$out DEVPFX=$dev install
  '';

  meta = with lib; {
    description = "Standalone version of MinaCalc along with a C API for easy access and bindings.";
    homepage = "https://github.com/kangalio/minacalc-standalone";
    #license = # Unknown
    platforms = platforms.linux;
  };
})