#!/usr/bin/env nu

const repoInfo = {
  org: itzg
  repo: minecraft-server
}

def getManifest [tag: string]: nothing -> string {
  http get (
    {
      scheme: https
      host: hub.docker.com
      path: ("/v2/namespaces" | path join $repoInfo.org | path join "repositories" | path join $repoInfo.repo | path join "tags" | path join $tag)
    }
    | url join
  )
  | get images
  | where $it.architecture == "amd64"
  | get 0.digest
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

def getNixData [ filePath: string ]: nothing -> record {
  nix store prefetch-file --json $"file://($filePath)"
  | from json
}

def --wrapped skopeo [...args] {
  nix shell nixpkgs#skopeo --command "skopeo" ...$args
}

def genHash [manifest: string ]: nothing -> string {
  let workFile = mktemp --dry --suffix ".gz"
  let destUrl = $"docker-archive://($workFile):($repoInfo.org)($repoInfo.repo):latest"
  let imageUrl = (
    {
      scheme: docker
      host: docker.io
      path: $"($repoInfo.org | path join $repoInfo.repo)@($manifest)"
    }
    | url join
  )
  skopeo --insecure-policy copy $imageUrl $destUrl
  let nixData = getNixData $workFile
  rm $workFile
  return $nixData.hash
}

def main [ packagePath: string ] {
  let version = $packagePath | str replace --regex `.*/(.+)` `$1`
  let manifest = getManifest $version
  let hash = genHash $manifest
  {
    name: $"($repoInfo.org)/($repoInfo.repo)"
    download: {
      manifest: $manifest
      hash: $hash
    }
  }
  | to json
  | save --force ($packagePath | path join "info.json")
}
