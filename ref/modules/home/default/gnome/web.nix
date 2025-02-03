{ pkgs, ... }:

{
  programs.gnome-web = {
    enable = true;
    extensions = {
      packages = with pkgs.web-extensions; [
        darkreader
        don-t-fuck-with-paste
        ublock-origin
        old-reddit-redirect
        reddit-enhancement-suite
      ];
      enabled = [
        "Don't Fuck With Paste"
        #"Dark Reader"
        "uBlock Origin"
        "Old Reddit Redirect"
        "Reddit Enhancement Suite"
      ];
      permissions = { };
    };
    settings = {
      searchEngine = "Google";
      extra-dconf = {
        use-google-search-suggestions = true;
      };
    };
  };
}
