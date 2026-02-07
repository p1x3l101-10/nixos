{ lib
, stdenv
, fetchFromGitHub 
, jq
, extraPrompts ? [] # Array of { prompt = ""; label = ""; }
, ...
}:

stdenv.mkDerivation {
  name = "prompt-dataset.csv";

  src = fetchFromGitHub {
    owner = "NyarchLinux";
    repo = "Smart-Prompts";
    tag = "0.3";
    hash = "sha256-5d2v4Gm1iOpI+7Bf8LJwczw7DwQB1lqbPgm9tdFKYZI=";
  };

  nativeBuildInputs = [
    jq
  ];

  buildPhase = ''
    echo "${builtins.toJSON extraPrompts}" > extraPrompts.json
    cat extraPrompts.json | jq -r '.[]| join(",")' > extraPrompts.csv
    cat dataset.csv extraPrompts.csv > mergedDataset.csv
  '';
  
  installPhase = ''
    mv mergedDataset.csv $out
  '';
}
