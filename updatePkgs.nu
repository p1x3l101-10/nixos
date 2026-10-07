#!/usr/bin/env nu

const flakePath = path self | path dirname
const packagesWithUpdaters = [
  "osu-lazer-bin"
  "voices-of-the-void"
]

def --wrapped "nix run" [...args] {
  ^nix run ...$args
}

def main [] {
  cd $flakePath
  $packagesWithUpdaters
  | each { |package|
    print $"(ansi blue)>>> Updating package ($package)(ansi reset)"
    let updateScript = nix eval $"($flakePath)#($package).meta.passthru.updateScript"
    run-external $updateScript
  }
}
