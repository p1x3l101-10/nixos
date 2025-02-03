{ lib, config, options, pkgs, ... }: # Ooo complex inputs!
with lib;
let
  cfg = config.programs.gnome-web;
  attrSetTypes = {
    searchEngines = {
      url = mkOption {
        description = "Full url of search engine with query field";
        type = types.str;
        example = ''
          https://duckduckgo.com/?t=epiphany&q=%s
        '';
      };
      bang = mkOption {
        description = "Bang for search term";
        type = types.str;
        example = ''
          !ddg
        '';
      };
      name = mkOption {
        description = "Name of the search engine";
        type = types.str;
        example = ''
          DuckDuckGo
        '';
      };
    };
  };
in

{
  options.programs.gnome-web = {
    enable = mkEnableOption "Gnome Web";
    extensions = {
      packages = mkOption {
        description = "Extensions to be installed";
        type = with types; listOf (uniq package);
        example = ''
          [
            pkgs.web-extensions.dark-reader
            pkgs.web-extensions.ublock-origin
          ]
        '';
      };
      permissions = mkOption {
        description = "Accepted extension permissions";
        type = with types; attrs;
        example = ''
          {
            "{45d4d1a3-4faa-42b7-9747-bcf2153310cd}" = {
              name = "boring-rss";
              permissions = [
                "activeTab"
              ];
            };
          }
        '';
      };
      enabled = mkOption {
        description = "Enabled extension names";
        type = with types; listOf str;
      };
    };
    settings = {
      adblock = mkOption {
        description = "Enable AdBlock";
        type = types.bool;
        default = true;
        example = "false";
      };
      searchEngine = mkOption {
        description = "Default search engine";
        type = types.str;
        default = "DuckDuckGo";
        example = "Google";
      };
      searchEngineProviders = mkOption {
        description = "All search engines";
        type = with types; listOf (submodule attrSetTypes.searchEngines);
        default = [
          { name = "Bing"; url = "https://www.bing.com/search?q=%s"; bang = "!b"; }
          { name = "DuckDuckGo"; url = "https://duckduckgo.com/?q=%s&t=epiphany"; bang = "!ddg"; }
          { name = "Google"; url = "https://www.google.com/search?q=%s"; bang = "!g"; }
        ];
      };
      homepageUrl = mkOption {
        description = "URL of homepage";
        type = types.str;
        default = "about:newtab";
        example = "https://google.com";
      };
      contentFilters = mkOption {
        description = "Filters for web";
        type = with types; listOf str;
        default = [
          "https://easylist-downloads.adblockplus.org/easylist_min_content_blocker.json"
          "https://better.fyi/blockerList.json"
          "https://gitlab.com/eyeo/filterlists/contentblockerlists/-/raw/master/easylist+easylistchina-minified.json"
        ];
      };
      extra-dconf = mkOption {
        description = "Extra dconf config values";
        default = { };
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.extensions.packages != [ ]) {
      xdg.dataFile = builtins.listToAttrs (map
        (ext: {
          name = "epiphany/web_extensions/" + ext.pname + ".xpi";
          value = { source = "${ext}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${ext.addonId}.xpi"; };
        })
        cfg.extensions.packages);
      home.packages = [ pkgs.epiphany ];
      dconf.settings = mkIf (cfg.extensions.packages != [ ]) {
        "org/gnome/epiphany/web".enable-webextensions = true;
        "org/gnome/epiphany/web".webextensions-active = cfg.extensions.enabled;
      };
      # Require permissions to be agreed to
      assertions = lib.mapAttrsToList
        (k: v:
          let
            unaccepted = lib.subtractLists
              v.permissions
              config.nur.repos.rycee.firefox-addons.${v.name}.meta.mozPermissions;
          in
          {
            assertion = unaccepted == [ ];
            message = ''
              Extension ${v.name} has unaccepted permissions: ${builtins.toJSON unaccepted}
            '';
          })
        cfg.extensions.permissions;
    })
    /*
      {
      dconf.settings."org/gnome/epiphany".search-engine-providors = with lib.hm.gvariant; (map (se:
        [
          (mkDictionaryEntry "url" (mkVariant se.url))
          (mkDictionaryEntry "bang" (mkVariant se.bang))
          (mkDictionaryEntry "name" (mkVariant se.name))
        ]
      ) cfg.settings.searchEngineProviders );
      }
    */
    {
      dconf.settings."org/gnome/epiphany" = with cfg.settings; {
        homepage-url = homepageUrl;
        content-filters = contentFilters;
      };
    }
    {
      dconf.settings."org/gnome/epiphany" = cfg.settings.extra-dconf;
    }
  ]);
}
