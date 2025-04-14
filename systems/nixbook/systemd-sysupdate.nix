{ pkgs, lib, self, ... }:

let
  nixbookSystem = self.nixosConfigurations.nixbook;
  closure = pkgs.closureInfo {
    rootPaths = [ nixbookSystem.config.system.build.toplevel ];
  };
  updateVersion = self.rev;
  UKI = nixbookSystem.config.system.build.uki + "/" + nixbookSystem.config.system.build.uki.name;
in {
  system-update = pkgs.runCommand "nixbook-update-${updateVersion}" {
    nativeBuildInputs = [ pkgs.coreutils pkgs.nix ];
  } ''
    mkdir -p $out/${updateVersion}
    cp ${UKI} $out/${updateVersion}/system.uki
    cp ${closure}/store-paths $out/${updateVersion}/closure.txt
    mkdir -p "$out/${updateVersion}/store"
    while read path; do
      if [[ "$path" ~= "(?<=\/nix\/store\/)[^\/]*empty-dir" ]]; then
        mkdir -p "$out/${updateVersion}/store/''${BASH_REMATCH[1]}""
      else
        cp -a --parents "$path" "$out/${updateVersion}/store/"
      fi
    done < ${closure}/store-paths

    cat > $out/${updateVersion}/update.conf <<EOF
[Update]
Version=${updateVersion}
EOF
  '';
  system = nixbookSystem.config.system.build.toplevel;
}