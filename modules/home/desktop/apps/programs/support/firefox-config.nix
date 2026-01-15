{
  svg.context-properties.content.enabled = true;
  browser = {
    search.suggest.enabled = true;
    startup.page = 0;
    firefox-view.feature-tour = builtins.toJSON {
      message = "FIREFOX_VIEW_FEATURE_TOUR";
      screen = "";
      complete = true;
    };
    discovery.enabled = false;
    contentblocking.category = "strict";
  };
  widget = {
    dmabuf.force-enabled = true;
    use-xdg-desktop-portal.file-picker = 1;
  };
  gemera.smoothScroll = true;
  app = {
    update.auto = false;
    shield.optoutstudies = false;
  };
  extensions = {
    autoDisableScopes = 0;
    getAddons.showPane = false;
    htmlaboutaddons.recommendations.enabled = false;
  };
  cookiebanners = {
    bannerClicking.enabled = true;
    service = {
      "mode.privateBrowsing" = 1;
      mode = 1;
    };
  };
  privacy = {
    trackingprotection = {
      enabled = true;
      pbmode.enabled = true;
      emailtracking.enabled = true;
      socialtracking.enabled = true;
      cryptomining.enabled = true;
      fingerprinting.enabled = true;
      fingerprintingProtection = true;
      resistFingerprinting = true;
      "resistFingerprinting.pbmode" = true;
      query_stripping = {
        enabled = true;
        "enabled.pbmode" = true;
      };
    };
  };
  zen = {
    welcome-screen.seen = true;
    view = {
      sidebar-expanded = false;
      use-single-toolbar = false;
    };
    workspaces.seperate-essentials = false;
    window-sync.enabled = false;
  };
  network.auth.subresource-http-auth-allow = 1;
  fission.autostart = true;
}
