{ stdenvNoCC
, dash
, callPackage
, writeTextFile
, mozilla-addons-to-nix ? callPackage ../../packages/mozilla-addons-to-nix { }
}:

let
  extensions-json = writeTextFile {
    name = "extensions.json";
    text = builtins.toJSON (import ./extensions.nix);
  };
in

stdenvNoCC.mkDerivation {
  name = "extensions.nix-locker";
  src = ./.;
  nativeBuildInputs = [ dash mozilla-addons-to-nix ];
  outputs = [ "out" ];
  buildPhase = ''
    echo "#!${dash}/bin/dash" >> build.sh
    echo "${mozilla-addons-to-nix}/bin/mozilla-addons-to-nix ${extensions-json} ./extensions.nix.locked" >> build.sh
  '';
  installPhase = ''
    mv build.sh $out
    chmod +x $out
  '';
}
