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
    rev = "1b3111654c6962fdf3f458823a94be7490433f7f";
    hash = "sha256-j68MJaUgGUEcNh8+g6ggwUV4A+Xn2AzTc1Qq1XbkT48=";
  };
}
