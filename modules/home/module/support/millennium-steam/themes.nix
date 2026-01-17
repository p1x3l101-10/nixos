{ fetchZip, fetchFromGitHub }:

{
  NEVKO-UI = fetchFromGitHub {
    owner = "dotFelixan";
    repo = "NEVKO-UI";
    rev = "e8ef4a2c92603e6fcd18dd4a22215de30ab27090";
    hash = "sha256-nmt4ZE6GwDl36qvqmyj+6PxtxJ+Mgd00I+4zHBL5uJo=";
  };
}
