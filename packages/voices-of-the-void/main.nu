#!/usr/bin/env nu

use std/log

const votvRoot = "@@VOTV_UNWRAPPED_PKG@@/libexec/voicesofthevoid"
const umuConf = {
  protonPath: "@@PROTON_PATH@@"
  gameId: "@@UMU_GAMEID@@"
  store: "@@UMU_STORE@@"
}
let gameData = $env.XDG_DATA_HOME | path join "voicesofthevoid"
let cacheDir = $env.XDG_CACHE_HOME | path join "voicesofthevoid"
let winePrefix = $env.XDG_STATE_HOME | path join "voicesofthevoid"
let winePrefixUserPath = $winePrefix | path join "drive_c/users" | path join $env.USER
let votvWinData = $winePrefixUserPath | path join "AppData/Local/VotV"

def --wrapped umu-run [
  --exec
  ...args
] {
  $env.STORE = $umuConf.store
  $env.GAMEID = $umuConf.gameId
  $env.PROTONPATH = $umuConf.protonPath
  $env.WINEPREFIX = $winePrefix
  if $exec {
    exec winediscordipcbridge-steam.sh umu-run ...$args
  } else {
    ^umu-run ...$args
  }
}

def ensurePath [
  path: string
  type: string
  logMessage: string
  action: closure
] {
  if not ($path | path exists) {
    log warning $logMessage
    do $action
  }
  if ($path | path type) != $type {
    log critical "Unable to proceed, the following path needs to be removed manually"
    log critical $path
    exit 1
  }
}

def --wrapped main [...args] {
  # Ensure needed directories exist
  ensurePath $winePrefix dir "Creating new VotV Wine Prefix" {
  # NOTE: Because umu will exit when it isnt running anything, be sure to wrap this so the script continues
    do -i { umu-run "" }
  }
  ensurePath $gameData dir "Creating new VotV data directory" { mkdir $gameData }

  # Ensure data link exists
  ensurePath $votvWinData symlink "Linking VotV data directory into Wine Prefix" {
    mkdir ($votvWinData | path dirname) # Ensure parent
    ln -s $gameData $votvWinData
  }

  # Massage the cache directories into something more sane
  ensurePath $cacheDir dir "Making Wine Prefix use XDG cache instead of internal caches" { mkdir $cacheDir }
  [
    ($winePrefix | path join "drive_c/windows/temp")
    ($winePrefixUserPath | path join "Temp")
  ]
  | each { |tmpDir|
    if ($tmpDir | path exists) and (($tmpDir | path type) != symlink) {
      log debug $tmpDir
      rm -r $tmpDir
      ln -s $cacheDir $tmpDir
    }
    if not ($tmpDir | path exists) {
      log debug $tmpDir
      mkdir ($tmpDir | path dirname)
      ln -s $cacheDir $tmpDir
    }
  }

  # Launch game
  log info "Launching Voices of the Void through UMU"
  umu-run --exec ($votvRoot | path join "VotV.exe") ...$args
}
