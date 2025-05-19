{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage (finalAttrs: {
  pname = "eleventy";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "11ty";
    repo = "eleventy";
    rev = "v${finalAttrs.version}";
    hash = lib.fakeHash;
  };

  npmDepsHash = lib.fakeHash;

  meta = with lib; {
    description = "A simpler site generator. Transforms a directory of templates (of varying types) into HTML.";
    homepage = "https://www.11ty.dev";
    license = licenses.mit;
    mainProgram = "eleventy";
  };
})