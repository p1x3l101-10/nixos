{ lib
, stdenv
, fetchFromGitHub
, openjdk8
, openjdk17
, pkgconf
, libbz2
, liblzma
, libz
, libzstd
, gettext
, libxml2
, jre8 ? openjdk8
, jre17 ? openjdk17
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "trios";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "wispborne";
    repo = "TriOS";
    tag = "v${finalAttrs.version}";
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [
    pkgconf
  ];

  buildInputs = [
    libbz2
    liblzma
    libz
    libzstd
    gettext
    libxml2

    # Java versions that starsector can be launched with
    jre8
    jre17
  ];

  meta = with lib; {
    description = "Starsector mod manager & toolkit.";
    homepage = "https://fractalsoftworks.com/forum/index.php?topic=29674.0";
    license = [
      # Custom license
      {
        name = "TriOS Community License v1.0";
        # Not extensive use, so the license will inherit from Apache-2.0
        inherit (lib.licenses.asl20) free depricated spdxId url redistributable;
      }
    ];
    platforms = platforms.linux;
  };
})
