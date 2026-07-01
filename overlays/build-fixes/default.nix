final: prev: {
  assimp = prev.assimp.overrideAttrs (oldAttrs: {
    doCheck = false;
  });
}
