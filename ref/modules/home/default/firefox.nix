{ config, lib, pkgs, ... }:
let
  nur = config.nur;
  search.engines = {
    "Nixpkgs" = {
      urls = [{
        template = "https://search.nixos.org/packages";
        params = [
          { name = "channel"; value = "unstable"; }
          { name = "type"; value = "packages"; }
          { name = "query"; value = "{searchTerms}"; }
        ];
      }];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@np" ];
    };
    "NixOS Option Search" = {
      urls = [{
        template = "https://search.nixos.org/options";
        params = [
          { name = "channel"; value = "unstable"; }
          { name = "sort"; value = "relevance"; }
          { name = "size"; value = "50"; }
          { name = "query"; value = "{searchTerms}"; }
        ];
      }];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@no" ];
    };
    "NixOS Wiki" = {
      urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
      iconUpdateURL = "https://nixos.wiki/favicon.png";
      updateInterval = 24 * 60 * 60 * 1000; # every day
      definedAliases = [ "@nw" ];
    };
    "Home Manager Option Search" = {
      urls = [{ template = "https://home-manager-options.extranix.com/?query={searchTerms}"; }];
      iconUpdateURL = "https://home-manager-options.extranix.com/favicon.png";
      updateInterval = 24 * 60 * 60 * 1000; # every day
      definedAliases = [ "@hm" ];
    };
    "Bing".metaData.hidden = true;
    "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
  };
  serach = {
    default = "Google";
    privateDefault = "DuckDuckGo";
    force = true;
  };

  extensions = with nur.repos; (with rycee.firefox-addons; [
    augmented-steam
    darkreader
    don-t-fuck-with-paste
    localcdn
    reddit-enhancement-suite
    return-youtube-dislikes
    rsf-censorship-detector
    sponsorblock
    ublock-origin
    web-scrobbler
    youtube-nonstop
    zoom-redirector
  ]);
  firefox-gnome-theme = {
    source = (fetchTarball {
      url = "https://github.com/rafaelmardojai/firefox-gnome-theme/archive/refs/tags/v122.tar.gz";
      sha256 = "0mack8i6splsywc5h0bdgh1njs4rm8fsi0lpvvwmbdqmjjlkz6a1";
    });
  };
in
{
  # Theme
  home.file = {
    ".mozilla/firefox/default/chrome/firefox-gnome-theme" = firefox-gnome-theme;
    ".mozilla/firefox/bw1n4bxf.default/chrome/firefox-gnome-theme" = firefox-gnome-theme;
  };

  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox
      (pkgs.firefox-unwrapped.override {
        pipewireSupport = true;
      })
      {
        extraPolicies = {
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          DNSOverHTTPS.enabled = true;
          ManualAppUpdateOnly = true;
          gnomeTheme = {
            hideWebrtcIndicator = true;
            hideUnifiedExtensions = true;
            hideSingleTab = true;
            systemIcons = true;
          };
        };
      };

    profiles = {
      # Personal
      "default" = {
        inherit extensions search;

        bookmarks = [
          { name = "NixOS Options Search"; url = "https://search.nixos.org/options"; }
          { name = "Home Manager Options"; url = "https://mipmip.github.io/home-manager-option-search"; }
        ];
        id = 1;
        isDefault = true;
        name = "Personal";
        userChrome = ''
          @import "firefox-gnome-theme/userChrome.css";
        '';
        userContent = ''
          @import "firefox-gnome-theme/userContent.css";
        '';
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.tabs.drawInTitlebar" = true;
          "svg.context-properties.content.enabled" = true;
        };
      };

      # School
      "bw1n4bxf.default" = {
        inherit extensions search;

        id = 0;
        isDefault = false;
        name = "School";
        userChrome = ''
          @import "firefox-gnome-theme/userChrome.css";
        '';
        userContent = ''
          @import "firefox-gnome-theme/userContent.css";
        '';
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.tabs.drawInTitlebar" = true;
          "svg.context-properties.content.enabled" = true;
        };
      };
    };
  };

  # Firefox Shortcuts
  xdg.desktopEntries = {
    firefox-school = rec {
      exec = "${config.programs.firefox.finalPackage}/bin/firefox -P School --name \"${name}\"";
      icon = "firefox-developer-icon";
      name = "Firefox Developer";
      genericName = "Web Browser";
      type = "Application";
      startupNotify = true;
      mimeType = [
        "text/html"
        "text/xml"
        "application/xhtml+xml"
        "application/vnd.mozilla.xul+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
      categories = [ "Network" "WebBrowser" ];
      actions = {
        new-private-window = {
          name = "New Private Window";
          exec = "${exec} --private-window";
        };
        new-window = {
          name = "New Window";
          exec = "${exec} --new-window";
        };
        profile-manager-window = {
          name = "Profile Manager";
          exec = "${exec} --ProfileManager";
        };
      };
    };
  };

  # Force no conflicts bc FF is dumb and rewrites it's files
  home.file.".mozilla/firefox/bw1n4bxf.default/search.json.mozlz4".force = lib.mkForce true;
  home.file.".mozilla/firefox/default/search.json.mozlz4".force = lib.mkForce true;
}
