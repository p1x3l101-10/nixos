# Stolen from `https://github.com/fufexan/nix-gaming/blob/master/pkgs/osu-lazer-bin/default.nix`
# Pulling from their info.json for updates
## Current changes: Added $PIPEWIRE_QUANTUM as well for crackling

{ ext,
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
  symlinkJoin,
  gamemode,
  pipewire_latency ? "64/44100", # reasonable default
  pipewire_quantum ? pipewire_latency, # Added by me to help with crackling
  gmrun_enable ? true, # keep this flag for compatibility
  command_prefix ?
    if
      gmrun_enable
    # won't hurt users even if they don't have it set up
    then
      "${gamemode}/bin/gamemoderun"
    else
      null,
  releaseStream ? "lazer",
  osu-mime ? ext.inputs.nix-gaming.packages."${ext.system}".osu-mime
}:
let
  pkgPath = ext.inputs.nix-gaming.outPath + "/pkgs/osu-lazer-bin";
  pname = "osu-lazer-bin";
  info = (builtins.fromJSON (builtins.readFile (pkgPath + "/info.json"))).${releaseStream};
  inherit (info) version;

  src = fetchurl {
    url = "https://github.com/ppy/osu/releases/download/${version}/osu.AppImage";
    inherit (info) hash;
  };

  derivation = appimageTools.wrapType2 {
    inherit version pname src;

    extraPkgs = pkgs: [ pkgs.icu ];

    extraInstallCommands =
      let
        contents = appimageTools.extract { inherit pname version src; };
      in
      ''
          . ${makeWrapper}/nix-support/setup-hook
        mv -v $out/bin/${pname} $out/bin/osu!

        wrapProgram $out/bin/osu! \
          --set PIPEWIRE_LATENCY "${pipewire_latency}" \
          --set PIPEWIRE_QUANTUM "${pipewire_quantum}" \
          --set OSU_EXTERNAL_UPDATE_PROVIDER "1" \
          --set OSU_EXTERNAL_UPDATE_STREAM "${releaseStream}" \
          --set vblank_mode "0"

        ${
          # a hack to infiltrate the command in the wrapper
          lib.optionalString (builtins.isString command_prefix) ''
            sed -i '$s:exec -a "$0":exec ${command_prefix}:' $out/bin/osu!
          ''
        }

        install -m 444 -D ${contents}/osu!.desktop $out/share/applications/osu-lazer.desktop
        for i in 16 32 48 64 96 128 256 512 1024; do
          install -D ${contents}/osu.png $out/share/icons/hicolor/''${i}x$i/apps/osu.png
        done
      '';
  };
in
symlinkJoin {
  name = "${pname}-${version}";
  paths = [
    derivation
    osu-mime
  ];

  meta = {
    description = "Rhythm is just a *click* away";
    longDescription = "osu-lazer extracted from the official AppImage to retain multiplayer support.";
    homepage = "https://osu.ppy.sh";
    /*
    license = with lib.licenses; [
      mit
      cc-by-nc-40
      unfreeRedistributable # osu-framework contains libbass.so in repository
    ];
    */
    mainProgram = "osu!";
    passthru.updateScript = pkgPath + "/update.sh";
    platforms = [ "x86_64-linux" ];
  };
}
