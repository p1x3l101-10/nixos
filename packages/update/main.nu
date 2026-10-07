#!/usr/bin/env nu

let flakePath = ls /etc/nixos -Dla | get 0.target
let timestampFile = $flakePath | path join ".git/nu-hooks/update-timestamp"
const updateCooldown = 1day
const packagesWithUpdaters = [
  "osu-lazer-bin"
  "voices-of-the-void"
]

def --wrapped "nix run" [...args] {
  ^nix run ...$args
}

def --wrapped "nix flake" [...args] { nom flake ...$args }

def mainLog [message] {
  print $"(ansi blue)>>> ($message)(ansi reset)"
}

def makeTimestamp []: nothing -> nothing {
  if not ($timestampFile | path dirname | path exists) {
    mkdir ($timestampFile | path dirname)
  }
  if ($timestampFile | path exists) {
    rm $timestampFile
  }
  touch $timestampFile
}

def checkTimestamp []: nothing -> bool {
  if not ($timestampFile | path exists) {
    return true
  }
  let lastRun = (ls -la $timestampFile | get 0.created)
  return ($lastRun > $updateCooldown)
}

def main [] {
  cd $flakePath
  $packagesWithUpdaters
  | each { |package|
    let infoPath = $flakePath | path join "packages" | path join $package | path join "info.json"
    let oldHash = open $infoPath | hash sha256
    mainLog $"Updating package ($package)"
    let updateScript = nix eval $"($flakePath)#($package).meta.passthru.updateScript"
    run-external $updateScript
    let newHash = open $infoPath | hash sha256
    if $oldHash != $newHash {
      git add ($flakePath | path join "packages" | path join $package | path join "info.json")
      return true
    } else {
      mainLog "No update was performed"
      return false
    }
  }
  | where $it
  | if ($in != []) {
    mainLog "Commiting package updates"
    git commit --message "Update package locks"
  } else {
    mainLog "No package updates were available"
  }
  if (checkTimestamp) {
    mainLog "Updating flake"
    nix flake update --commit-lock-file
    makeTimestamp
  } else {
    mainLog "Skipping flake update"
  }
  mainLog "Updates complete"
  return
}
