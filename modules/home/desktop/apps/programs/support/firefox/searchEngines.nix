{ ext, lib, pkgs, ... }:

let
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
in {
  default = "Startpage";
  engines = ext.lib.attrsets.mergeAttrs [
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
}
