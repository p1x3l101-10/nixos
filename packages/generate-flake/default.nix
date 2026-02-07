{ lib
, writeShellApplication
, nixVersions
}:

writeShellApplication {
  name = "generate-flake";
  runtimeInputs = [
    nixVersions.latest
  ];
  text = builtins.readFile ./generate-flake.bash;
}