#!/usr/bin/env nu

const repoAddr = "ful1e5/BreezeX_Cursor"
const apiHeaders = {
  X-GitHub-Api-Version: "2026-03-10"
  Accept: "application/vnd.github+json"
}

# Adds any auth token from the environment if needed/available
def "ghApi envApiHeaders" []: nothing -> record {
  if (($env.GITHUB_API_TOKEN? | default null) != null) {
    return (
      $apiHeaders
      | upsert Authorization $"Bearer ($env.GITHUB_API_TOKEN)"
    )
  } else {
    return $apiHeaders
  }
}

# Make a GET request to the github api
def "ghApi GET" [ path: string ]: nothing -> any {
  let url = (
    {
      scheme: https
      host: api.github.com
      path: $path
    } | url join
  )
  http get $url --headers (ghApi envApiHeaders)
}

def getNixHash []: string -> string {
  let url = $in
  ^nix store prefetch-file --hash-type sha256 --json $url
  | from json
  | get hash
}

def getSrcUrl []: string -> string {
  let attrPath = $in
  ^nix eval $".#($attrPath).src.url"
  | str replace --all `"` ""
}

def main [ packagePath: string ] {
  let latestRelease = (
    ghApi GET ("/repos" | path join $repoAddr | path join "releases")
    | first
    | get tag_name
  )
  let revision = (
    ghApi GET ("/repos" | path join $repoAddr | path join "commits" | path join $latestRelease)
    | get sha
  )
  let attrPath = (
    $packagePath
    | str replace "legacyPackages/" ""
    | str replace --all "/" "."
  )
  {
    version: ($latestRelease | str replace "v" "")
    src: {
      rev: $revision
      hash: ($attrPath | getSrcUrl | getNixHash)
    }
  }
  | save --force ($packagePath | path join "info.json")
}
