{ infuse, ... }:


final: prev: infuse prev {
  assimp.__output.doCheck.__assign = false;
  pythonPackagesExtensions.__overlay.patool.__output.doCheck.__assign = false;
}
