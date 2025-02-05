{ symlinkJoin
, nix
}:

symlinkJoin {
  name = nix.pname;
  paths = [ nix ];
  postBuild = ''
    # Remove nix2 symlinks
    for bin in $out/bin/*; do
      if [[ "$(basename "$bin")" != "nix" ]] ; then
        rm -v "$bin"
      fi
    done
    # Fix nix-daemon.service to use `nix daemon`
    sed -i 's|^ExecStart=.*|ExecStart=@${nix}/bin/nix daemon|' $out/lib/systemd/system/nix-daemon.service
  '';
}