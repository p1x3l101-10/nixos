{ config, ext, ... }:

{
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
          firefox-color
          ublock-origin
          sponsorblock
          return-youtube-dislikes
          ipfs-companion
          old-reddit-redirect
          reddit-enhancement-suite
        ];
        settings."FirefoxColor@mozilla.com".settings = {
          firstRunDone = true;
          theme = {
            title = "Stylix ${config.lib.stylix.colors.description}";
            images.additional_backgrounds = [ "./bg-000.svg" ];
            colors = let
              inherit (config.lib.stylix) colors;
              mkColor = color: {
                r = colors."${color}-rgb-r";
                g = colors."${color}-rgb-g";
                b = colors."${color}-rgb-b";
              };
            in {
              toolbar = mkColor "base00";
              toolbar_text = mkColor "base05";
              frame = mkColor "base01";
              tab_background_text = mkColor "base05";
              toolbar_field = mkColor "base02";
              toolbar_field_text = mkColor "base05";
              tab_line = mkColor "base0D";
              popup = mkColor "base00";
              popup_text = mkColor "base05";
              button_background_active = mkColor "base04";
              frame_inactive = mkColor "base00";
              icons_attention = mkColor "base0D";
              icons = mkColor "base05";
              ntp_background = mkColor "base00";
              ntp_text = mkColor "base05";
              popup_border = mkColor "base0D";
              popup_highlight_text = mkColor "base05";
              popup_highlight = mkColor "base04";
              sidebar_border = mkColor "base0D";
              sidebar_highlight_text = mkColor "base05";
              sidebar_highlight = mkColor "base0D";
              sidebar_text = mkColor "base05";
              sidebar = mkColor "base00";
              tab_background_separator = mkColor "base0D";
              tab_loading = mkColor "base05";
              tab_selected = mkColor "base00";
              tab_text = mkColor "base05";
              toolbar_bottom_separator = mkColor "base00";
              toolbar_field_border_focus = mkColor "base0D";
              toolbar_field_border = mkColor "base00";
              toolbar_field_focus = mkColor "base00";
              toolbar_field_highlight_text = mkColor "base00";
              toolbar_field_highlight = mkColor "base0D";
              toolbar_field_separator = mkColor "base0D";
              toolbar_vertical_separator = mkColor "base0D";
            };
          };
        };
      };
      settings = let inherit (config.stylix) fonts; in {
        "svg.context-properties.content.enabled" = true;
		    "browser.search.suggest.enabled" = true;
		    "font.name.monospace.x-western" = fonts.monospace.name;
        "font.name.sans-serif.x-western" = fonts.sansSerif.name;
        "font.name.serif.x-western" = fonts.serif.name;
      };
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
}
