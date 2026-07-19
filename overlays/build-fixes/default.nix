final: prev: {
  assimp = prev.assimp.overrideAttrs (oldAttrs: {
    doCheck = false;
  });
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (pFinal: pPrev: {
      patool = pPrev.patool.overrideAttrs (old: {
        doCheck = false;
      });
    })
  ];
}
