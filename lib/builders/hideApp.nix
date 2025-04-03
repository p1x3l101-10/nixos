{ lib, ext, self }:

let
  inherit (ext) pkgs;
in
{
  hideApp = { pkg, name ? pkg.name }: lib.hiPrio (pkgs.runCommand "${name}.desktop-hide" { } ''
    mkdir -p "$out/share/applications"
    cat ${pkg}/share/applications/${name}.desktop" > "$out/share/applications/${name}.desktop"
    echo "NoDisplay=1" >> $out/share/applications/${name}.desktop"
  '');
}
