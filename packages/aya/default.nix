{ lib
, buildGoModule
, fetchgit
, aya
, stdenv
, ...
}:

buildGoModule {
  name = "aya";
  src = fetchgit {
    url = "https://git.yakumo.dev/yakumo.izuru/aya";
    rev = "9307af7e09530096eaf2647e630dd70cb9f2ee24";
    hash = "sha256-e3GwP+HN5DrqgKNMOcZqleHikT6vq08EXo4bjNmz5m0=";
  };

  vendorHash = "sha256-7JtEbrG3Q5YV8paxfngB5doLaC65+mqab6ihXxAxgi4=";

  outputs = [
    "out"
  ];

  installPhase = ''
    mkdir -p $out
    dir="$GOPATH/bin"
    [ -e "$dir" ] && cp -vr $dir $out
    mkdir -vp $out/share/man/man1
    cp -v aya.1 $out/share/man/man1/aya.1
  '';

  # For building sites
  passthru.build = { src, service, env ? { }, buildInputs ? [ ] }: stdenv.mkDerivation
    {
      name = "aya-build";
      inherit src;
      nativeBuildInputs = [
        aya
      ] ++ buildInputs;
      patchPhase = ''
        cp -r ${service} ./.aya
      '';
      buildPhase = ''
        aya build
      '';
      installPhase = ''
        mv ./.pub $out
      '';
    } // (# Extra envvars needed
    lib.listToAttrs (
      lib.forEach (lib.attrsToList env) (x:
        {
          # Format the envvars so aya takes them
          name = "AYA_${lib.toUpper x.name}";
          inherit (x) value;
        }
      )
    )
  );

  meta = with lib; {
    name = "Aya";
    description = "The fastest static site generator";
    homepage = "https://suzunaan.yakumo.dev/aya/";
    license = licenses.mit;
    platforms = lib.platforms.unix;
  };
}
