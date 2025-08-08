{ config, lib, ... }:

{
  programs.thunderbird = {
    enable = true;
    nativeMessagingHosts = [];
    profiles.default = {
      isDefault = true;
      extensions = [];
      settings = lib.internal.attrsets.compressAttrs "." (lib.internal.attrsets.mergeAttrs [(import ./support/firefox-config.nix) {
        font.name = {
          monospace.x-western = config.stylix.fonts.monospace.name;
          sans-serif.x-western = config.stylix.fonts.sansSerif.name;
          serif.x-western = config.stylix.fonts.serif.name;
        };
        toolkit.legacyUserProfileCustomizations.stylesheets = true;
        svg.context-properties.content.enabled = true;
      }]);
      userChrome = builtins.readFile (config.programs.zen-browser.profiles."mlls93c4.Default (beta)".userChrome);
      userContent = builtins.readFile (config.programs.zen-browser.profiles."mlls93c4.Default (beta)".userContent);
    };
  };
  home.sessionVariables.MOZ_ENABLE_WAYLAND = 1;
}
