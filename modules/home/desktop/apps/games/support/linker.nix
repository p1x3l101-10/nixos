{ lib
, writeShellApplication
}:

{ pathsToLink ? []
, defaults ? []
}:

let
  dirs = builtins.concatStringsSep " " (map
    (x: "'${x}'")
    pathsToLink
  );
  ddirs = builtins.concatStringsSep " " (map
    (x: "'${x}'")
    defaults
  );
in writeShellApplication {
  name = "mc-linker";
  text = ''
    # Args
    INST_ID="$1"

    # Vars
    GLOBALS_DIR="''${XDG_DATA_HOME:-"$HOME/.local/share"}/minecraftGlobals"

    # Run
    mkdir -p "$GLOBALS_DIR"
    for dir in ${dirs}; do
      INST_FILE="$INST_MC_DIR/$dir"
      GLOBAL_FILE="$GLOBALS_DIR/$dir"
      if [[ -L "$INST_FILE" ]]; then
        # Skip if already a link
        true
      elif [[ -e "$GLOBAL_FILE" ]]; then
        ln -sfv "$GLOBAL_FILE" "$INST_FILE"
      else
        mv -v "$INST_FILE" "$GLOBAL_FILE"
        ln -sv "$GLOBAL_FILE" "$INST_FILE"
      fi
    done
    for dir in ${ddirs}; do
      INST_FILE="$INST_MC_DIR/$dir"
      GLOBAL_FILE="$GLOBALS_DIR/$dir"
      if [[ ! -e "$GLOBAL_FILE" ]]; then
        if [[ -e "$INST_FILE" ]]; then
          cp -vr "$INST_FILE" "$GLOBAL_FILE"
        fi
      fi
      if [[ ! -e "$INST_FILE" ]]; then
        if [[ -e "$GLOBAL_FILE" ]]; then
          cp -vr "$GLOBAL_FILE" "$INST_FILE"
        fi
      fi
    done
  '';
}
