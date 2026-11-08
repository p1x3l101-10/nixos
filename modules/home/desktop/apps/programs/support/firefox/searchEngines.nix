{ ext, lib, pkgs, ... }:

let
  svgToPng = fileName: input: builtins.addErrorContext "While converting an SVG to a PNG" (pkgs.runCommand fileName { } ''
    ${pkgs.imagemagick}/bin/magick ${input} $out
  '');
  icons = {
    nixSnowflake = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    nixvim = svgToPng "nixvim.png" "${ext.inputs.nixvim.outPath}/assets/nixvim_logo.svg";
  };
  inherit (ext.lib.firefox) mkSearchEngine mkSearchExtension;
  mkSimpleSearchExtension = prefix: queryParam: mkSearchExtension { inherit prefix queryParam; }; # Clunky calling syntax not needed if there are no url parameters
  mkNixosSearchExtension = source: channel: mkSearchExtension {
    prefix = "options";
    parameters = {
      inherit channel source;
    };
    queryParam = "query";
  };
in {
  default = "Startpage";
  engines = ext.lib.attrsets.mergeAttrs [
    (mkSearchEngine {
      name = "Startpage";
      urlBase = "https://www.startpage.com";
      searchExtension = mkSearchExtension {
        prefix = "do/dsearch";
        parameters = {
          cat = "web";
          language = "english";
        };
      };
      additionalUrlExtensions = [
        # Search suggestions
        {
          ext = mkSearchExtension {
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
    (mkSearchEngine {
      name = "Nixpkgs Search";
      urlBase = "https://search.nixos.org";
      searchExtension = mkSearchExtension {
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
    (mkSearchEngine {
      name = "NixOS Options";
      urlBase = "https://search.nixos.org";
      searchExtension = mkNixosSearchExtension "nixos" "unstable";
      extraParams = {
        channel = "unstable";
      };
      iconFile = icons.nixSnowflake;
      aliases = [ "no" "nixos" ];
    })
    (mkSearchEngine {
      name = "Home Manager Options";
      urlBase = "https://search.nixos.org";
      searchExtension = mkNixosSearchExtension "home_manager" "unstable";
      extraParams = {
        channel = "unstable";
      };
      iconFile = icons.nixSnowflake;
      aliases = [ "nh" "hm" "homemanager" ];
    })
    (mkSearchEngine {
      name = "Nix Modular Services Options";
      urlBase = "https://search.nixos.org";
      searchExtension = mkNixosSearchExtension "modular_service" "unstable";
      extraParams = {
        channel = "unstable";
      };
      iconFile = icons.nixSnowflake;
      aliases = [ "ns" "ms" "modularservice" ];
    })
    (mkSearchEngine {
      name = "NixOS Wiki";
      urlBase = "https://wiki.nixos.org";
      searchExtension = mkSimpleSearchExtension "w/index.php" "search";
      aliases = [ "nw" "nixwiki" "nixoswiki" ];
    })
    (mkSearchEngine {
      name = "Nixvim Option Search";
      urlBase = "https://nix-community.github.io/nixvim";
      searchExtension = mkSimpleSearchExtension "search/options" "query";
      alias = "nixvim";
      iconFile = icons.nixvim;
    })
    (mkSearchEngine {
      name = "Noogle";
      urlBase = "https://noogle.dev";
      searchExtension = mkSimpleSearchExtension "q" "term";
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
