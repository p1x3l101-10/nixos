{ eLib, ... }:

let
  mkCache = cachixLoc: key: {
    substituters = [ "https://${cachixLoc}.cachix.org" ];
    trusted-public-keys = [ "${cachixLoc}.cachix.org-1:${key}" ];
  };
in {
  nix.settings = eLib.attrsets.mergeAttrs [
    (mkCache "unmojang" "OfHnbBNduZ6Smx9oNbLFbYyvOWSoxb2uPcnXPj4EDQY=")
    (mkCache "nix-community" "mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=")
    (mkCache "hyprland" "a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=")
    (mkCache "nix-gaming" "nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=")
    (mkCache "nix-citizen" "lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo=")
  ];
}
