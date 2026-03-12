{ lib
, stdenv
, fetchFromGitHub
, gnu-efi
, grub2
}:

let
  inherit (stdenv.hostPlatform.system) efiArch;
in

stdenv.mkDerivation (final: {
  name = "efifs";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "pbatard";
    repo = "efifs";
    tag = final.version;
    hash = lib.fakeHash;
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    gnu-efi
    grub2
  ];

  patchPhase = ''
    patch -d grub -Np1 -i 0001-GRUB-fixes.patch
  '';

  buildPhase = ''
    make ARCH='${efiArch}'
  '';

  installPhase = ''
    install -D -m644 src/*.efi -t "$out/usr/lib/efifs"
  '';

  meta = with lib; {
    description = "Standalone EFI file system drivers";
    homepage = "https://efi.akeo.ie/";
    license = licenses.gplv3;
    platform = platforms.linux;
  };
})
