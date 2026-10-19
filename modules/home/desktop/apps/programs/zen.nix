{ config, pkgs, ext, lib, ... }@hmArgs:

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
          youtube-nonstop
          youtube-no-translation
          youtube-shorts-block
          varia-integrator
          ubo-scope
          tetrio-plus
          terms-of-service-didnt-read
          temporary-containers-plus
          nekocap
          modrinthify
          google-container
          facebook-container
          disconnect
          zen-internet
        ];
      };
      mods = [
        "642854b5-88b4-4c40-b256-e035532109df" # Transparency
        "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better find bar
        "d8b79d4a-6cba-4495-9ff6-d6d30b0e94fe" # Better active tab
        "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No sidebar scrollbar
      ];
      settings = ext.lib.attrsets.compressAttrs "." (import ./support/firefox-config.nix);
      search = {
        force = true;
        default = "Startpage";
        engines = let
          svgToPng = fileName: input: builtins.addErrorContext "While converting an SVG to a PNG" (pkgs.runCommand fileName { } ''
            ${pkgs.imagemagick}/bin/magick ${input} $out
          '');
          icons = {
            nixSnowflake = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            nixvim = svgToPng "nixvim.png" "${ext.inputs.nixvim.outPath}/assets/nixvim_logo.svg";
          };
          procParameters = parameters: builtins.addErrorContext "While processing url parameters" (builtins.concatStringsSep "&"
            (map
              ({ name, value }: "${name}=${value}")
              (lib.attrsets.attrsToList parameters)
            )
          );
          mkSE = builtins.addErrorContext "While defining the rest of a search URL" (
            { prefix
            , parameters ? {}
            , queryParam ? "q"
            , noQuery ? false
            }: builtins.concatStringsSep "" [
              prefix
              "?"
              (procParameters parameters)
              (if ((builtins.length (lib.attrsets.attrsToList parameters)) > 0) then "&" else "")
              (if noQuery then "" else "${queryParam}=")
            ]
          );
          mkSimpleSE = prefix: queryParam: mkSE { inherit prefix queryParam; }; # Clunky calling syntax not needed if there are no url parameters
          mkNixosSE = source: channel: mkSE {
            prefix = "options";
            parameters = {
              inherit channel source;
            };
            queryParam = "query";
          };
          mkSearch = builtins.addErrorContext "While defining a search engine" (
            { name
            , searchExtension
            , urlBase
            , updateInterval ? 24 * 60 * 60 * 1000 # In seconds
            , noIcon ? false
            , iconFile ? null
            , alias ? null
            , aliases ? []
            , dontPrefixAlias ? false
            , aliasPrefix ? "@"
            , extraParams ? {}
            , extraOptions ? {}
            , additionalUrlExtensions ? [] # Instead of `template`, use `ext`
            , additionalUrls ? []
            }:
            {
              "${name}" = ext.lib.attrsets.mergeAttrs [
                {
                  inherit name updateInterval;
                  urls = (
                    [{ template = "${urlBase}/${searchExtension}{searchTerms}"; }]
                    ++ (map
                      ({ ext, ... }@x: {
                        template = "${urlBase}/${ext}";
                      } // (builtins.removeAttrs x ["ext"]))
                      additionalUrlExtensions
                    )
                    ++ additionalUrls
                  );
                  params = lib.attrsets.attrsToList (
                    { query = "{searchTerms}"; } // extraParams
                  );
                }
                (
                  if (builtins.isNull iconFile) then (
                    if (!noIcon) then {
                      iconMapObj."16" = "${urlBase}/favicon.ico";
                    } else {}
                  ) else {
                    icon = iconFile;
                  }
                )
                (
                  let
                    prefix = if (dontPrefixAlias) then "" else aliasPrefix;
                  in if (builtins.isNull alias) then (
                    if (aliases != []) then {
                      definedAliases = (map
                        (x: "${prefix}${x}")
                        aliases
                      );
                    } else {}
                  ) else {
                    definedAliases = [ "${prefix}${alias}" ];
                  }
                )
                extraOptions
              ];
            }
          );
        in ext.lib.attrsets.mergeAttrs [
          (mkSearch {
            name = "Startpage";
            urlBase = "https://www.startpage.com";
            searchExtension = mkSE {
              prefix = "do/dsearch";
              parameters = {
                cat = "web";
                language = "english";
              };
            };
            additionalUrlExtensions = [
              # Search suggestions
              {
                ext = mkSE {
                  prefix = "suggestions";
                  parameters = {
                    q = "{searchTerms}";
                    format = "opensearch";
                    segment = "startpage.defaultffx";
                    lui = "english";
                  };
                  noQuery = true;
                };
                type = "application/x-suggestions+json";
              }
            ];
            aliases = [ "s" "startpage" ];
          })
          (mkSearch {
            name = "Nixpkgs Search";
            urlBase = "https://search.nixos.org";
            searchExtension = mkSE {
              prefix = "packages";
              parameters = {
                channel = "unstable";
              };
              queryParam = "query";
            };
            extraParams = {
              channel = "unstable";
            };
            iconFile = icons.nixSnowflake;
            aliases = [ "np" "nixpkgs" ];
          })
          (mkSearch {
            name = "NixOS Options";
            urlBase = "https://search.nixos.org";
            searchExtension = mkNixosSE "nixos" "unstable";
            extraParams = {
              channel = "unstable";
            };
            iconFile = icons.nixSnowflake;
            aliases = [ "no" "nixos" ];
          })
          (mkSearch {
            name = "Home Manager Options";
            urlBase = "https://search.nixos.org";
            searchExtension = mkNixosSE "home_manager" "unstable";
            extraParams = {
              channel = "unstable";
            };
            iconFile = icons.nixSnowflake;
            aliases = [ "nh" "hm" "homemanager" ];
          })
          (mkSearch {
            name = "Nix Modular Services Options";
            urlBase = "https://search.nixos.org";
            searchExtension = mkNixosSE "modular_service" "unstable";
            extraParams = {
              channel = "unstable";
            };
            iconFile = icons.nixSnowflake;
            aliases = [ "ns" "ms" "modularservice" ];
          })
          (mkSearch {
            name = "NixOS Wiki";
            urlBase = "https://wiki.nixos.org";
            searchExtension = mkSimpleSE "w/index.php" "search";
            aliases = [ "nw" "nixwiki" "nixoswiki" ];
          })
          (mkSearch {
            name = "Nixvim Option Search";
            urlBase = "https://nix-community.github.io/nixvim";
            searchExtension = mkSimpleSE "search/options" "query";
            alias = "nixvim";
            iconFile = icons.nixvim;
          })
          (mkSearch {
            name = "Noogle";
            urlBase = "https://noogle.dev";
            searchExtension = mkSimpleSE "q" "term";
            aliases = [ "ng" "noogle" ];
            iconFile = icons.nixSnowflake;
          })
          # Remove unwanted search engines
          {
            google.metaData.hidden = true;
            "amazondotcom-us".metaData.hidden = true;
            "bing".metaData.hidden = true;
            "ebay".metaData.hidden = true;
          }
        ];
      };
      bookmarks = {
        force = true;
        settings = (ext.lib.firefox.transcribeBookmarks (import ./support/firefox/bookmarks.nix hmArgs));
      };
    };
  };
  home.sessionVariables.MOZ_ENABLE_WAYLAND = 1;
}
