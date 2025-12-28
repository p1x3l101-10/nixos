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
        NONMATCHING="/run/systemCleanup/nonMatches.lst"

        # Create needed dirs
        mkdir -p "/run/systemCleanup"
        mkdir -p "${cfg.trashDir}"

        # Find undesired files
        find "${cfg.baseDir}" -type d -print | grep -Fxvf "$CONFIG" | sort | awk '
        NR==1 { prev=$0; print; next }
        index($0, prev "/") != 1 {
          prev=$0
          print
        }' > "$NONMATCHING"

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
