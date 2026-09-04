{ fetchZip, fetchFromGitHub }:

{
  NEVKO-UI = fetchFromGitHub {
    owner = "dotFelixan";
    repo = "NEVKO-UI";
    rev = "e8ef4a2c92603e6fcd18dd4a22215de30ab27090";
    hash = "sha256-nmt4ZE6GwDl36qvqmyj+6PxtxJ+Mgd00I+4zHBL5uJo=";
  };
  SpaceTheme = fetchFromGitHub {
    owner = "SpaceTheme";
    repo = "Steam";
    rev = "96837647ee0c59010db2e432896c7bfcb94f9933";
    hash = "sha256-plS3emPWpNWBxoJt/xim5LohojLokxwmQpz1w9+zytw=";
  };
}
