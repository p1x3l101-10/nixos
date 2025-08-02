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
  };
  fission.autostart = true;
}
