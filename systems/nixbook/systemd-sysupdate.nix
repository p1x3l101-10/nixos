{ pkgs, lib, self, ... }:

let
  nixbookSystem = self.nixosConfigurations.nixbook;
  closureTxt = pkgs.runCommand "closure.txt" {
    buildInputs = [ pkgs.nix ];
  } ''
    nix-store -qR ${nixbookSystem.config.system.build.toplevel} | sort > $out
  '';
  updateVersion = self.rev;
in {
  system-update = pkgs.runCommand "nixbook-update-${updateVersion}" {
    nativeBuildInputs = [ pkgs.coreutils pkgs.nix ];
  } ''
    mkdir -p $out/${updateVersion}
    cp ${nixbookSystem.config.system.build.uki} $out/${updateVersion}/system.uki
    cp ${closureTxt} $out/${updateVersion}/closure.txt

    cat > $out/${updateVersion}/update.conf <<EOF
[Update]
Version=${updateVersion}
EOF
  '';
  system = nixbookSystem.config.system.build.toplevel;
}