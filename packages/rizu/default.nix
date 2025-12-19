{ lib
, stdenv
, fetchFromGitHub
, callPackage
, love
, p7zip
, libbass
, libbass_fx
, libbassmix
#, libbassopus
, libiconvReal
, discord-rpc
, libiconv
, fftw
, sqlite
, rtmidi
, lua
, minacalc ? callPackage ./minacalc.nix {}
, writeShellApplication
}:

let
  lua = lua.withPackages(ps: with ps; [
    luasocket
    luaossl
    luasec
    bcrypt
    md5
    utf8
    lsqlite3
    etlua
    luacov
    luacov-reporter-lcov
    nginx-lua-prometheus
    enet
  ]);

  genNatives = let
    plainLibMap = [
      "${libbass}/lib/libbass.so"
      "${libbass_fx}/lib/libbass_fx.so"
      "${libbassmix}/lib/libbassmix.so"
      "${libiconvReal}/lib/libcharset.so"
      "${libiconvReal}/lib/libiconv.so"
      "${discord-rpc}/lib/libdiscord-rpc.so"
      "${fftw}/lib/libfftw3.so"
      "${rtmidi}/lib/librtmidi.so.7"
      "${minacalc}/lib/libminacalc.so"
    ];
    libMap = {
      "7z" = "${p7zip.lib}/lib/p7zip/7z.so";
    };
    libMapRaw = {
      "luamidi.so" = "/dev/null";
      "video.so" = "/dev/null";
    };
    libMapFinal = (
      ((builtins.listToAttrs
        (map
          (x:
            {
              name = builtins.baseNameOf x;
              value = x;
            }
          )
          plainLibMap
        )
      ) // libMapRaw)
    ) // (lib.mapAttrs'
      (k: v:
        {
          name = "lib${k}.so";
          value = v;
        }
      )
      libMap
    );
  in (builtins.concatStringsSep ";"
    (map
      (x:
        "ln -s \"${x.value}\" \"bin/linux64/${x.name}\""
      )
      (lib.listToAttrs
        libMapFinal
      )
    )
  );

  linkPaths = [
    "userdata"
    "logs"
    "temp"
    "storages"
  ];

  rizuBase = stdenv.mkDerivation (self: {
    name = "rizu";
    version = "28.07.2024";

    src = fetchFromGitHub {
      owner = "semyon422";
      repo = "soundsphere";
      tag = self.version;
      hash = lib.fakeHash;
    };

    buildInputs = [
      love
      p7zip.lib
      libbass
      libbass_fx
      libbassmix
      minacalc
      libiconv
      discord-rpc
      fftw
      sqlite
      rtmidi
    ];

    nativeBuildInputs = [];

    buildPhase = ''
      # Remove provided natives (replace them with our own)
      cp bin/linux64/luamidi.so .
      cp bin/linux64/video.so .
      cp bin/linux64/libbassopus.so .
      rm -rf bin

      # Link the new natives
      mkdir -p bin/linux64
      ${genNatives}
      mv luamidi.so bin/linux64
      mv luamidi.so bin/linux64
      mv libbassopus.so bin/linux64

      # defaults to add for the user
      mkdir defaults
      mv ui defaults
      mv userdata defaults
      mv temp defaults
      mkdir -p defaults/logs
      mkdir -p defaults/storages/charts
      mkdir -p defaults/storages/replays

      # Create symlinks
      for file in ${builtins.concatStringsSep " " linkPaths}; do
        ln -s "/tmp/rizu/$file" $file
      done 
    '';

    installPhase = ''
      mkdir -p $out/libexec/rizu
      mv ./* $out/libexec/rizu
    '';

    meta = with lib; {
      description = "VSRG written in Lua";
      homepage = "https://rizu.su";
      #license = licenses.gpl3OrLater;
      platforms = platforms.linux;
    };
  });
in

writeShellApplication {
  name = "rizu";
  runtimeInputs = [
    love
    rizuBase
  ];
  text = ''
    # Reset link dir
    rm -rf /tmp/rizu
    mkdir /tmp/rizu

    USER_BASEDIR="${XDG_DATA_HOME:-"$HOME/.local/share"}/rizu"

    # Set default contents of the data dir
    if [[ ! -e "$USER_BASEDIR" ]]; then
      cp -r "${rizuBase}/libexec/rizu/defaults" "$USER_BASEDIR"
    fi

    # Link in the aliases
    for file in ${builtins.concatStringsSep " " linkPaths}; do
      ln -s "$USER_BASEDIR/$file" "/tmp/rizu/$file"
    done

    # Launch Rizu
    cd "${rizuBase}/libexec/rizu"
    export LD_LIBARY_PATH="$LD_LIBRARY_PATH:$PWD/bin/linux64"
    exec "love ."
  '';
}