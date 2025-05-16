{ lib
, buildGoModule
, fetchgit
, go
}:

buildGoModule {
  name = "aya";
  src = fetchgit {
    url = "https://git.yakumo.dev/yakumo.izuru/aya";
    rev = "9307af7e09530096eaf2647e630dd70cb9f2ee24";
    hash = lib.fakeHash;
  };

  vendorHash = lib.fakeHash;

  outputs = [
    "out"
    "doc"
  ];

  installPhase = ''
    install -Dm755 $GOPATH/bin/myprogram $out/bin/myprogram
    install -Dm644 docs/myprogram.1 $doc/share/man/man1/myprogram.1
  '';

  meta = with lib; {
    name = "Aya";
    description = "The fastest static site generator";
    homepage = "https://suzunaan.yakumo.dev/aya/";
    license = licenses.mit;
    platforms = lib.platforms.unix;
  };
}