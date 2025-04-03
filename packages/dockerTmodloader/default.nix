{ lib
, dockerTools
, imageName ? "jacobsmile/tmodloader1.4"
, imageDigest ? "sha256:af96b0dac94979a601b977b08a703e963389cd6549668e3e1a0bd95039bf8e3b"
, sha256 ? "sha256-hpHv7TAEJyFcP5PqLQfgpPAo3eqvw5L4EWVcTIqv6v4="
}:

dockerTools.pullImage {
  inherit imageName imageDigest sha256;
  finalImageName = "internal/docker-tmodloader";
  finalImageTag = "latest";
  os = "linux";
  arch = "x86_64";
}
