{ channels, nur, ... }:

final: prev: {
  nur = import nur {
    nurpkgs = prev;
    pkgs = prev;
    repoOverrides = { };
  };
}
