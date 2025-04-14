{ pkgs, lib, self, ... }:

let
  nixbookSystem = self.nixosConfigurations.nixbook;
  closure = pkgs.closureInfo {
    rootPaths = [ nixbookSystem.config.system.build.toplevel ];
  };
  updateVersion = self.rev;
  UKI = nixbookSystem.config.system.build.uki + "/" + nixbookSystem.config.system.build.uki.name;
  storeTarball = pkgs.runCommand "store.tar.xz" {
    nativeBuildInputs = [ closure pkgs.gnutar pkgs.coreutils pkgs.findutils ];
  } ''
    mkdir -p tmp-root

    while read path; do
      if [ -d "$path" ]; then
        # If it's a directory, recreate it explicitly with parents
        mkdir -p "tmp-root$path"
      else
        # Copy file or symlink, preserving full store path
        cp -a --parents "$path" tmp-root/
      fi
    done < ${closure}/store-paths

    tar cvJf $out -C tmp-root .
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