{ lib
, kodiPackages
, fetchFromGitHub
}:

kodiPackages.buildKodiAddon rec {
  pname = "The TVDB v4";
  namespace = "metadata.tvshows.thetvdb.com.v4.python";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "thetvdb";
    repo = "metadata.tvshows.thetvdb.com.v4.python";
    rev = "${version}";
    sha256 = "sha256-hBoM+WF+tGC+koSJBhMqhWOrQ/923cc/xpbEUPuMz+Q=";
  };

  passthru.pythonPath = "lib/api";

  meta = with lib; {
    homepage = "https://kodi.wiki/view/Add-on:The_TVDB_v4";
    description = "Scraper for The TVDB";
    license = licenses.gpl2Plus;
    maintainers = teams.kodi.members;
  };
}
