{ channels, self, nixpkgs, ... }:

final: prev: {
  inherit (channels.unstable)
    craftos-pc
    ;
}
