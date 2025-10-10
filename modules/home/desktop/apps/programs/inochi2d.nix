{ pkgs, ... }:

let
  cmakeOverride = pkg: (pkg.overrideAttrs (oldAttrs: {
      cmakeFlags = oldAttrs.cmakeFlags ++ [
        "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
      ];
  }));
in {
  home.packages = with pkgs; [
    (cmakeOverride inochi-session)
    (cmakeOverride inochi-creator)
  ];
}
