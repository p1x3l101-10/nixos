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
    rev = "9f5b9ea8fabc9cd3c4f46b638d78daa9c3da97dd";
    hash = "sha256-F97C41F41wbz8Ot4DD0LkKkFx+aQu90Pv/IyBmIs2jM=";
  };
}
