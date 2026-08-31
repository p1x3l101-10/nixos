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
        engines = let
          svgToPng = fileName: input: pkgs.runCommand fileName { } ''
            ${pkgs.imageMagick}/bin/magick ${input} $out
          '';
          icons = {
            nixSnowflake = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            nixvim = svgToPng "nixvim.png" "${ext.inputs.nixvim.outPath}/assets/nixvim_logo.svg";
          };
          procParameters = parameters: (builtins.concatStringsSep "&"
            (map
              ({ name, value }: "${name}=${value}")
              (builtins.attrsToList parameters)
            )
          );
          mkSE = (
            { prefix
            , parameters ? {}
            , queryParam ? "q"
            , noQuery ? false
            }: builtins.concatStringsSep "" [
              prefix
              "?"
              (procParameters parameters)
              (if ((builtins.length (builtins.attrsToList parameters)) > 0) then "&" else "")
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
          mkSearch = (
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
                      } // (builtins.removeAttrs ["ext"] x))
                      additionalUrlExtensions
                    )
                    ++ additionalUrls
                  );
                  params = lib.attrsToList (
                    ext.lib.attrsets.mergeAttrs (
                      { query = "{searchTerms}"; } // extraParams
                    )
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
                        (x: "${prefix}${alias}")
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
