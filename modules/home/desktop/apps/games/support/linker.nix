{ lib
, writeShellApplication
}:

{ pathsToLink ? [] }:

let
  dirs = builtins.concatStringsSep " " (map
    (x: "'${x}'")
    pathsToLink
  );
in writeShellApplication {
  name = "mc-linker";
  text = ''
    # Args
    INST_ID="$1"

    # Vars
    PRISMLAUNCHER_INST_DIR="''${XDG_DATA_HOME:-"$HOME/.local/share"}"/PrismLauncher/instances"
    GLOBALS_DIR="''${XDG_DATA_HOME:-"$HOME/.local/share"}"/minecraftGlobals"

    # Run
    mkdir -p "$GLOBALS_DIR"
    for dir in ${dirs}; do
      INST_FILE="$PRISMLAUNCHER_INST_DIR/$INST_ID/$dir"
      GLOBAL_FILE="$GLOBALS_DIR/$dir"
      if [[ -L "$INST_FILE" ]]; then
        # Skip if already a link
        true
      elif [[ -e "$GLOBAL_FILE ]]; then
        ln -sfv "$GLOBAL_FILE" "$INST_FILE"
      else
        mv -v "$INST_FILE" "$GLOBAL_FILE"
        ln -sv "$GLOBAL_FILE" "$INST_FILE"
      fi
    done
  '';
}
