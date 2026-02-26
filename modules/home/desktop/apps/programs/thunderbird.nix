{ config, lib, pkgs, ... }:

{
  home.packages = [ pkgs.gpgme ];
  programs.thunderbird = {
    enable = true;
    nativeMessagingHosts = [ ];
    profiles.default = {
      isDefault = true;
      extensions = [ ];
      withExternalGnupg = true;
      settings = lib.internal.attrsets.compressAttrs "." (lib.internal.attrsets.mergeAttrs [
        (import ./support/firefox-config.nix)
        {
          font.name = {
            monospace.x-western = config.stylix.fonts.monospace.name;
            sans-serif.x-western = config.stylix.fonts.sansSerif.name;
            serif.x-western = config.stylix.fonts.serif.name;
          };
          toolkit.legacyUserProfileCustomizations.stylesheets = true;
          svg.context-properties.content.enabled = true;
          mail.openpgp = {
            alternative_gpg_path = "${config.programs.gpg.package}/bin/gpg";
            allow_external_gnupg = true;
            fetch_pubkeys_from_gnupg = true;
          };
        }
      ]);
      inherit (config.programs.zen-browser.profiles."mlls93c4.Default (beta)") userChrome userContent;
    };
  };
  home.sessionVariables.MOZ_ENABLE_WAYLAND = 1;
}
