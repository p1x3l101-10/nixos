#!/usr/bin/env nu

use std/log

const infoPath = "packages/osu-lazer-bin/info.json"
const releaseApi = "https://api.github.com/repos/ppy/osu/releases"
const releaseTypes = [ "lazer", "tachyon" ]

def prereleaseFilter [ releaseStream: string ]: bool -> bool {
  let isPrerelease = $in
  if $releaseStream == "lazer" {
    not $isPrerelease
  } else {
    $isPrerelease
  }
}

def genUrl [ version: string ]: nothing -> string {
  $"https://github.com/ppy/osu/releases/download/($version)/osu.AppImage"
}

def --wrapped "nix store" [ operation, ...args ]: nothing -> record {
  ^nix store $operation --json ...$args
}

def saveInfo []: record -> nothing {
  let info = $in
  log info "Saving info.json"
  $info
  | to json
  | save --force $infoPath
}

def main [] {
  log info "Loading information"
  let releases = http get $releaseApi | sort-by created_at | reverse
  let info = open $infoPath
  # Setup
  let workdir = mktemp --dry
  mkdir $workdir
  $releaseTypes
  | each { |releaseStream|
    log debug $"Checking for updates on stream `($releaseStream)`"
    let oldversion = $info | get $releaseStream | get version
    let latestValidRelease = $releases | where { |node| $node.prerelease | prereleaseFilter $releaseStream } | first
    let version = $latestValidRelease.tag_name
    if $version == $oldversion {
      log info $"No updates available for stream `($releaseStream)`"
      return {
        stream: $releaseStream
        data: ($info | get $releaseStream)
      }
    } else {
      log info $"Update found for stream `($releaseStream)`"
      let dlUrl = genUrl $version
      let downloadedFile = $workdir | path join $"osu!-($releaseStream).appimage"
      http get $dlUrl | save -p $downloadedFile
      let nixData = nix store prefetch-file $"file://($downloadedFile)"
      return {
        stream: $releaseStream
        data: {
          version: $version
          hash: $nixData.hash
        }
      }
    }
  }
  | each { |x|
    [
      $x.stream
      $x.data
    ]
  }
  | into record
  | saveInfo
  log info "Done"
}
