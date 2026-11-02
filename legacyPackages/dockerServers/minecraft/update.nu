#!/usr/bin/env nu

const repoInfo = {
  org: itzg
  repo: minecraft-server
}

def --wrapped "nix shell" [...args] {
  if ((which nom | where $it.type == "external") != []) {
    ^nom shell ...$args
  } else {
    ^nix shell ...$args
  }
}

def --wrapped "nix store" [...args] {
  ^nix store ...$args
}

def --wrapped nix-prefetch-docker [...args] {
  nix shell nixpkgs#nix-prefetch-docker --command nix-prefetch-docker ...$args
}

def prefetchImage [
  imageName: string
  imageTag: string
]: nothing -> record {
  nix-prefetch-docker --image-name $imageName --image-tag $imageTag --json
  | from json
}

def main [ packagePath: string ] {
  let version = $packagePath | str replace --regex `.*/(.+)` `$1`
  let imageName = $"($repoInfo.org)/($repoInfo.repo)"
  let prefetchedData = prefetchImage $imageName $version
  {
    name: $prefetchedData.imageName
    final: {
      imageName: $prefetchedData.finalImageName
      imageTag: $prefetchedData.finalImageTag
    }
    download: {
      manifest: $prefetchedData.imageDigest
      hash: $prefetchedData.hash
    }
  }
  | to json
  | save --force ($packagePath | path join "info.json")
}
