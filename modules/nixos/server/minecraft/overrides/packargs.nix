{ packId
, extraArgs ? []
}:

(import ./unsup.nix {
  url = "https://raw.githubusercontent.com/p1x3l101-10/${packId}/refs/heads/main/unsup.ini";
}) ++ extraArgs