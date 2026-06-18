{ ext
, lib
, stdenv
, nushell
}:

stdenv.mkDerivation {
  name = "find-inotify-hoggers";

  src  = ./.;
  
  buildInputs = [
    nushell
  ];

  installPhase = ''
    mkdir $out/bin -p
    cp ./find-inotify-hoggers.nu $out/bin/find-inotify-hoggers
    chmod +x $out/bin/find-inotify-hoggers
  '';
}
