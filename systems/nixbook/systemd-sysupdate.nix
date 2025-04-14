{ pkgs, lib, self, ... }:

let
  nixbookSystem = self.nixosConfigurations.nixbook;
  closure = pkgs.closureInfo {
    rootPaths = [ nixbookSystem.config.system.build.toplevel ];
  };
  updateVersion = self.rev;
  UKI = nixbookSystem.config.system.build.uki + "/" + nixbookSystem.config.system.build.uki.name;
  storeTarball = pkgs.runCommand "store-tarball" {
    nativeBuildInputs = [ closure pkgs.gnutar ];
  } ''
    mkdir -p tmp-root
    while read path; do
      cp -a --parents "$path" tmp-root/
    done < ${closure}/store-paths
    tar --zstd cvf $out -C tmp-root .
  '';
in {
  system-update = pkgs.runCommand "nixbook-update-${updateVersion}" {
    nativeBuildInputs = [ pkgs.coreutils pkgs.nix closure storeTarball ];
  } ''
    mkdir -p $out/${updateVersion}
    cp ${UKI} $out/${updateVersion}/system.uki
    cp ${closure}/store-paths $out/${updateVersion}/closure.txt
    cp ${storeTarball} $out/${updateVersion}/store.tar.zstd

    cat > $out/${updateVersion}/update.conf <<EOF
[Update]
Version=${updateVersion}
EOF
  '';
  system = nixbookSystem.config.system.build.toplevel;
}