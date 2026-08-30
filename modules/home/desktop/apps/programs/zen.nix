{ config, pkgs, ext, lib, ... }:

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
          startpage-private-search
        ];
      };
      settings = ext.lib.attrsets.compressAttrs "." (import ./support/firefox-config.nix);
      search = {
        force = true;
        default = "Startpage";
        engines = {
          Startpage = {
            urls = [
              { template = "https://www.startpage.com/do/dsearch?q={searchTerms}&cat=web&language=english"; }
              {
                template = "https://www.startpage.com/suggestions?q={searchTerms}&format=opensearch&segment=startpage.defaultffx&lui=english";
                type = "application/x-suggestions+json";
              }
            ];
            iconMapObj."16" = "https://www.startpage.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@s" "@startpage" ];
          };
          "Nixpkgs Search" = {
            urls = [{ template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}"; }];
            params = [
              { name = "query"; value = "{searchTerms}"; }
              { name = "channel"; value = "unstable"; }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@np" "@nixpkgs" ];
          };
          "NixOS Options" = {
            urls = [{ template = "https://search.nixos.org/options?channel=unstable&query={searchTerms}"; }];
            params = [
              { name = "query"; value = "{searchTerms}"; }
              { name = "channel"; value = "unstable"; }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@no" "@nixos" ];
          };
          "Home Manager Options" = {
            urls = [{ template = "https://search.nixos.org/options?channel=unstable&source=home_manager&query={searchTerms}"; }];
            params = [
              { name = "query"; value = "{searchTerms}"; }
              { name = "channel"; value = "unstable"; }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@nh" "@hm" "@homemanager" ];
          };
          "NixOS Wiki" = {
            name = "NixOS Wiki";
            urls = [{ template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; }];
            iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
            definedAliases = [ "@nw" "@nixwiki" ];
          };
          Noogle = {
            name = "Noogle";
            urls = [{ template = "https://noogle.dev/q/?term={searchTerms}"; }];
            iconMapObj."16" = "https://noogle.dev/favicon.ico";
            definedAliases = [ "@ng" "@noogle" ];
          };
          google.metaData.hidden = true;
          "amazondotcom-us".metaData.hidden = true;
          "bing".metaData.hidden = true;
          "ebay".metaData.hidden = true;
        };
      };
      bookmarks = {
        force = true;
        settings = (
          let
            mkBookmark = name: url: { inherit name url; };
          in [
            {
              name = "Toolbar";
              toolbar = true;
              bookmarks = [
                {
                  name = "College";
                  bookmarks = [
                    (mkBookmark "LMS" "https://occc.mrooms3.net")
                    (mkBookmark "Student Services" "https://experience.elluciancloud.com/occc151")
                    (mkBookmark "EMail" "https://outlook.cloud.microsoft/mail")
                    (mkBookmark "Homepage" "https://occc.edu")
                    (mkBookmark "Kahoot" "https://www.kahoot.it")
                  ];
                }
                {
                  name = "GSuite";
                  bookmarks = [
                    (mkBookmark "Calendar" "https://calendar.google.com")
                    (mkBookmark "EMail" "https://mail.google.com")
                  ];
                }
                (mkBookmark "Graphing Calculator" "https://desmos.com/calculator")
              ];
            }
          ]
        );
      };
    };
  };
  home.sessionVariables.MOZ_ENABLE_WAYLAND = 1;
}
