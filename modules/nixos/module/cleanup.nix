{ lib, pkgs, config, ... }:

let
  inherit (lib) mkOption types mkEnableOption mkIf;
  cfg = config.environment.cleanup;
  mkPatOpt = description: mkOption { inherit description; type = with types; nullOr path; default = null; };
in

{
  options.environment.cleanup = {
    enable = mkEnableOption "automated cleaning";
    baseDir = mkPatOpt "Base directory to clean";
    trashDir = mkPatOpt "Directory to move disallowed files (recommended to be on the same filesystem for speed)";
    allowedPaths = mkOption {
      description = "List of paths that will be ignored during cleaning";
      type = with types; listOf path;
    };
  };
  config = mkIf cfg.enable {
    environment.etc."systemCleanup/allowedPaths.lst".text = builtins.concatStringsSep "\n" (map (x: cfg.baseDir + x) cfg.allowedPaths);
    assertions = map (x: { assertion = !builtins.isNull cfg."${x}"; message = "environment.cleanup.${x} must be set!"; }) [
      "baseDir"
      "trashDir"
    ];
    systemd.services.systemCleanup = {
      script = ''
        CONFIG="/etc/systemCleanup/allowedPaths.lst"
        NONMATCHING_ALL="/run/systemCleanup/allNonMatches.lst"
        NONMATCHING="/run/systemCleanup/nonMatches.lst"

        # Create needed dirs
        mkdir -p "/run/systemCleanup"
        mkdir -p "${cfg.trashDir}"
        if [[ -e "$NONMATCHING" ]]; then
          rm -v "$NONMATCHING"
        fi

        # Find undesired files
        find "${cfg.baseDir}" -type d -print | grep -Fvf "$CONFIG" | sort > "$NONMATCHING_ALL"

        # Trim the list
        while read line; do
          if [[ ! "''${#line}" -lt "''${#prev_path}" ]]; then
            echo "$line" >> "$NONMATCHING"
          fi
          prev_line="$line"
        done < "$NONMATCHING_ALL"

        # Put them in purgatory
        while read line; do
          destination="${cfg.trashDir}/''${line#"${cfg.baseDir}/"}"
          mkdir -p "$(dirname "$destination")"
          mv -v "$line" "$destination"
        done < "$NONMATCHING"
      '';
    };
  };
}
