{ lib, ... }:

{
  programs.thunderbird = {
    enable = true;
    nativeMessagingHosts = [];
    profiles.default = {
      isDefault = true;
      extensions = [];
      settings = lib.internal.attrsets.compressAttrs "." (import ./support/firefox-config.nix);
    };
  };
  home.sessionVariables.MOZ_ENABLE_WAYLAND = 1;
}
