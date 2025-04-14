{ pkgs, lib, self, ... }:

let
  nixbookSystem = self.nixosConfigurations.nixbook;
  closure = pkgs.closureInfo {
    rootPaths = [ nixbookSystem.config.system.build.toplevel ];
  };
  closureTxt = pkgs.runCommand "closure.txt" ''
    cat "${closure}" | sort > $out
  '';
  updateVersion = self.rev;
in {
  system-update = pkgs.runCommand "nixbook-update-${updateVersion}" {
    nativeBuildInputs = [ pkgs.coreutils pkgs.nix ];
  } ''
    mkdir -p $out/${updateVersion}
    cp ${nixbookSystem.config.system.build.uki} $out/${updateVersion}/system.uki
    cp ${closureTxt} $out/${updateVersion}/closure.txt
    nix copy --to file://$out/${updateVersion}/store --no-check-sigs $(cat ${closureTxt})

    cat > $out/${updateVersion}/update.conf <<EOF
[Update]
Version=${updateVersion}
EOF
  '';
  system = nixbookSystem.config.system.build.toplevel;
}