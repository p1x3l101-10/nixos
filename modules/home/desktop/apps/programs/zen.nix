{ config, pkgs, ext, lib, ... }@hmArgs:

{
  stylix.targets.zen-browser.profileNames = [
    "mlls93c4.Default (beta)"
  ];
  programs.zen-browser = {
    enable = true;
    policies = import ./support/firefox/policies.nix hmArgs;
    profiles."mlls93c4.Default (beta)" = {
      isDefault = true;
      extensions = {
        force = true;
        packages = import ./support/firefox/extensions.nix hmArgs;
      };
      mods = [
        "642854b5-88b4-4c40-b256-e035532109df" # Transparency
        "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better find bar
        "d8b79d4a-6cba-4495-9ff6-d6d30b0e94fe" # Better active tab
        "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No sidebar scrollbar
      ];
      settings = ext.lib.attrsets.compressAttrs "." (import ./support/firefox/config.nix);
      search = {
        force = true;
        inherit (import ./support/firefox/searchEngines.nix hmArgs) default engines;
      };
      bookmarks = {
        force = true;
        settings = import ./support/firefox/bookmarks.nix hmArgs;
      };
    };
  };
  home.sessionVariables.MOZ_ENABLE_WAYLAND = 1;
}
