{ lib, pythonPkgs, fetchPypi, ... }:

pythonPkgs.buildPythonPackage (lib.fix (self: {
  pname = "wordllama";
  version = "0.3.9";
  src = fetchPypi {
    pname = "wordllama";
    inherit (self) version;
    hash = "sha256-p5tF/oKzd2trrLk0TTLOXppT9maG4imXaemhAYTRkvU=";
  };
  pyproject = true;
  build-system = with pythonPkgs; [ setuptools cython numpy setuptools-scm ];
  propagatedBuildInputs = with pythonPkgs; [
    numpy
    safetensors
    tokenizers
    toml
    pydantic
    requests
  ];
  meta = with lib; {
    homepage = "https://github.com/dleemiller/WordLlama";
    description = "Things you can do with the token embeddings of an LLM";
    license = licenses.mit;
  };
}))
