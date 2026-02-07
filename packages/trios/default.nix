{ lib
, fetchFromGitHub
, openjdk8
, openjdk17
, curlFull
, flutter
, jre8 ? openjdk8
, jre17 ? openjdk17
, ...
}:

flutter.buildFlutterApplication (lib.fix (finalAttrs: {
  pname = "trios";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "wispborne";
    repo = "TriOS";
    tag = finalAttrs.version;
    hash = "sha256-7ljCn6NMi1jifbCYUhiieNt/cMzl31U528o8aJLZR7c=";
  };

  # NOTE: need to redownload this file whenever I version bump
  pubspecLock = builtins.fromJSON (builtins.readFile ./pubspec.lock.json);

  buildInputs = [
    curlFull

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
}))
