#!/usr/bin/env nu

use std/log

const infoPath = "packages/voices-of-the-void/info.json"
const manifestUrl = "https://archive.votv.dev/manifest.json"
const allowPrerelease = false

def main [] {
  let manifest = http get $manifestUrl
  if $manifest.schemaVersion != 1 {
    log critical "Votv manifest schema version has changed, please apply an update to this script!"
    exit 1
  }
  if $allowPrerelease {
    log warning "Using prereleases"
  }
  let builds = $manifest.builds | where $it.gameId == "game_votv" | sort-by id | reverse
  let info = open $infoPath
  let latestBuild = (
    $builds
    | where { |build|
      if $allowPrerelease {
        return true
      } else {
        if ($build | get -o channel | default null) != null {
          return (
            ($build.channel | str contains "stable") and (not ($build.channel | str contains "unstable"))
          )
        }
      }
      return false
    }
    | first
  )

  if $info.download.version == $latestBuild.version {
    log info "No updates available"
    return
  }

  log info "Update available"
  $info
  | update download.version $latestBuild.version
  | update download.url $"($manifest.download.baseUrl)/($latestBuild.files.0.relPath)"
  | update download.sha256 $latestBuild.files.0.sha256
  | to json
  | save --force $infoPath
}
