#!/usr/bin/env nu

const infoPath = "modules/nixos/module/resources/minecraft/info.json"
const repoInfo = {
  org: itzg
  repo: minecraft-server
}
const javaVersions = [
  8
  17
  21
  25
]

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

def --wrapped skopeo [...args] {
  nom shell nixpkgs#skopeo --command "skopeo" ...$args
}

def genHash [manifest: string ]: nothing -> string {
  let destUrl = $"docker-archive:///tmp/image.gz:($repoInfo.org)($repoInfo.repo):latest"
  let imageUrl = (
    {
      scheme: docker
      host: docker.io
      path: $"($repoInfo.org | path join $repoInfo.repo)@($manifest)"
    }
    | url join
  )
  skopeo copy $imageUrl $destUrl
  let nixData = nix store prefetch-file $"file:///tmp/image.gz"
  rm /tmp/image.gz
  return $nixData.hash
}

def main [] {
}
