#!/usr/bin/env nu

let flakePath = ls /etc/nixos -Dla | get 0.target
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

def main [] {
  cd $flakePath
  $packagesWithUpdaters
  | each { |package|
    mainLog $"Updating package ($package)"
    let updateScript = nix eval $"($flakePath)#($package).meta.passthru.updateScript"
    run-external $updateScript
    git add ($flakePath | path join "packages" | path join $package | path join "info.json")
  }
  mainLog "Commiting package updates"
  git commit --message "Update package locks"
  mainLog "Updating flake"
  nix flake update --commit-lock-file
  mainLog "Updates complete"
  return
}
