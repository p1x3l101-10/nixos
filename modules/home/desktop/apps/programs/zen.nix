{ lib, ext, ... }:

{
  stylix.targets.zen-browser.profileNames = [
    "mlls93c4.Default (beta)"
  ];
  programs.zen-browser = {
    enable = true;
    policies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = true;
    };
    profiles."mlls93c4.Default (beta)" = {
      isDefault = true;
      extensions = {
        force = true;
        packages = with ext.inputs.nur.legacyPackages.${ext.system}.repos.rycee.firefox-addons; [
          stylus
          ublock-origin
          sponsorblock
          return-youtube-dislikes
          ipfs-companion
          old-reddit-redirect
          reddit-enhancement-suite
        ];
      };
      settings = lib.internal.attrsets.compressAttrs "." (import ./support/firefox-config.nix);
      search = {
        force = true;
        default = "google";
        engines = {
          google.metadata.alias = "@g";
          "NixOS Packages" = {
			      urls = [{ template = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}"; }];
			      icon = "https://nixos.org/favicon.png";
			      updateInterval = 24 * 60 * 60 * 1000;
			      definedAliases = [ "!ns" ];
			    };
			    "NixOS Options" = {
			      urls = [{ template = "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}"; }];
			      icon = "https://nixos.org/favicon.png";
			      updateInterval = 24 * 60 * 60 * 1000;
			      definedAliases = [ "!no" ];
			    };
			    "HomeManager" = {
			      urls = [{ template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master"; }];
			      icon = "https://github.com/mipmip/home-manager-option-search/blob/main/images/favicon.png";
			      updateInterval = 24 * 60 * 60 * 1000;
			      definedAliases = [ "!hs" ];
			    };
        };
      };
    };
  };
  home.sessionVariables.MOZ_ENABLE_WAYLAND = 1;
}
