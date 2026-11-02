dockerTools: basePath:

let
  info = builtins.fromJSON (builtins.readFile (basePath + "info.json"));
in
(dockerTools.pullImage {
  imageName = info.name;
  imageDigest = info.download.manifest;
  sha256 = info.download.hash;
  finalImageTag = "latest";
  finalImageName = "internal/docker-minecraft";
}) // {
  passthru.updateScript = ./update.nu;
  updateScript = ./update.nu;
}
