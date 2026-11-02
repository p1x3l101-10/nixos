dockerTools: basePath:

let
  info = builtins.fromJSON (builtins.readFile (basePath + "/info.json"));
in
(dockerTools.pullImage {
  imageName = info.name;
  imageDigest = info.download.manifest;
  sha256 = info.download.hash;
  finalImageTag = info.final.imageTag;
  finalImageName = info.final.imageName;
}) // {
  passthru.updateScript = ./update.nu;
  updateScript = ./update.nu;
}
