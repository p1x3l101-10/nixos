{ inputs, ... }:
let
  pfx = "/private/var/tmp/homebrew";
  appDir = pfx + "/Applications";
  user = "sblatt";
in {
  homebrew = {
    enable = true;
    brewPrefix = pfx;
    user = "sblatt";
    caskArgs = {
      no_quarantine = true;
      appdir = appDir;
    };
    global = {
      autoUpdate = false;
      cleanup = "uninstall";
    };
    onActivation = {
      upgrade = true;
      cleanup = "uninstall";
    };
  };
  nix-homebrew.prefixes."${pfx}" = {
    enable = true;
    inherit user;
    library = "${pfx}/Homebrew/Library";
    taps = with inputs; {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
      "homebrew/homebrew-services" = homebrew-services;
      "p1x3l101-10/homebrew-personal" = homebrew-personal;
      "unmojang/homebrew-unmojang" = homebrew-unmojang;
    };
    mutableTaps = false;
  };
  environment.extraInit = ''
    rm -r /Users/${user}/Application/Homebrew
    mkdir -p /Users/${user}/Application/Homebrew
    for app in $(find '${appDir}' -maxdepth 1 -name '*.app' -type d); do
      ln -sf "$app" "/Users/${user}/Application/Homebrew/$(basename $app)"
    done
  '';
}