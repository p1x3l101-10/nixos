{ ext, ... }:

let
  # Inject the token into the build so it doesn't read the envvar
  refreshToken = "eyJhbGciOiJIUzUxMiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIxMWUzMGNiMC01MzMxLTQ0M2UtYTBhMi00MTUwOGUzYzc5ZDAifQ.eyJleHAiOjE3OTIwMjEzNjMsImlhdCI6MTc5MjAxOTU2MywianRpIjoiOGE0Y2I4MDAtZWUzZC01Yjc4LTQyYjMtODEzNDVkNDAyN2IwIiwiaXNzIjoiaHR0cHM6Ly9hdXRoLmFod29vLmNvbS9yZWFsbXMvYWh3b28iLCJhdWQiOiJodHRwczovL2F1dGguYWh3b28uY29tL3JlYWxtcy9haHdvbyIsInN1YiI6IjM1NTM2NTllLTk5OGEtNDY4Ny1hOWExLTk1ZWU3OWYwOTYyYyIsInR5cCI6IlJlZnJlc2giLCJhenAiOiJhaHdvby1jbGllbnQiLCJzaWQiOiJOWDhnS1diai1NUlB4R3R1NmVaRExQUHIiLCJzY29wZSI6Im9wZW5pZCBhY3IgcHJvZmlsZSByb2xlcyB3ZWItb3JpZ2lucyBiYXNpYyBlbWFpbCBhaHdvby1jbGllbnQtc2NvcGUiLCJhdWRfeCI6WyJhaHdvby1jbGllbnQiLCJhY2NvdW50Il19.2aRj3TeLUtZUidw6Ffo71Flas4DlGyDsXSBCQlFZpJm8TErAklQjRCAIv_I3ZrN7rr0DKmiXwqcP4gD2QwJOHQ";
  ksaPkgs = ext.lib.infusion.infuse ext.selfPkgs {
    kitten-space-agency.__input.refreshToken.__assign = refreshToken;
  };
in

{
  home.packages = [
    ksaPkgs.kitten-space-agency
  ];
  xdg.desktopEntries.ksa = {
    categories = [
      "Game"
    ];
    exec = "kitten-space-agency-launcher %U";
    name = "Kitten Space Agency";
    terminal = false;
  };
}
