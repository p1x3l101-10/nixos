{ config, lib, ext, ... }:

{
  stylix.targets.zen-browser.profileNames = [
    "mlls93c4.Default (beta)"
  ];
  programs.zen-browser = {
    enable = true;
    policies = {
      AIControls = "blocked";
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DefaultDownloadDirectory = "${config.home.homeDirectory}/Downloads";
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
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
          keepassxc-browser
          redirect-to-wiki-gg
          unpaywall
          #tampermonkey
          stylus
          steam-database
          indie-wiki-buddy
          darkreader
        ];
      };
      settings = ext.lib.attrsets.compressAttrs "." (import ./support/firefox-config.nix);
      search = {
        force = true;
        default = "startpage";
        engines = {
          startpage = {
            urls = [{ template = "https://www.startpage.com/sp/search?query={searchTerms}"; }];
            iconMapObj."16" = "https://www.startpage.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@s" "@startpage" ];
          };
          "Nixpkgs Search" = {
            urls = [{ template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}"; }];
            params = [
              { name = "query"; value = "{searchTerms}"; }
              { name = "type"; value = "packages"; }
              { name = "channel"; value = "unstable"; }
            ];
            icon = "https://nixos.org/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@ns" "@nixpkgs" ];
          };
          "NixOS Wiki" = {
            name = "NixOS Wiki";
            urls = [{ template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; }];
            iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
            definedAliases = [ "@nw" "@nixwiki" ];
          };
          google.metaData.hidden = true;
          "amazondotcom-us".metaData.hidden = true;
          "bing".metaData.hidden = true;
          "ebay".metaData.hidden = true;
        };
      };
    };
  };
  home.sessionVariables.MOZ_ENABLE_WAYLAND = 1;
}
