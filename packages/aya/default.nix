{ lib
, buildGoModule
, fetchgit
}:

buildGoModule (finalAttrs: {
  name = "aya";
  src = fetchgit {
    url = "https://git.yakumo.dev/yakumo.izuru/aya";
    rev = "9307af7e09530096eaf2647e630dd70cb9f2ee24";
    hash = "sha256-e3GwP+HN5DrqgKNMOcZqleHikT6vq08EXo4bjNmz5m0=";
  };

  vendorHash = "sha256-7JtEbrG3Q5YV8paxfngB5doLaC65+mqab6ihXxAxgi4=";

  outputs = [
    "bin"
    "doc"
  ];

  installPhase = ''
    install -Dm755 $GOPATH/bin/aya $bin/bin/aya
    install -Dm644 aya.1 $doc/share/man/man1/aya.1
  '';

  meta = with lib; {
    name = "Aya";
    description = "The fastest static site generator";
    homepage = "https://suzunaan.yakumo.dev/aya/";
    license = licenses.mit;
    platforms = lib.platforms.unix;
  };
})