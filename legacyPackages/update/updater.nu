#!/usr/bin/env nu

def --wrapped "nix flake" [...args]: any -> any {
  if ((which nom | where $it.type == "external") != []) {
    ^nom flake ...$args
  } else {
    ^nix flake ...$args
  }
}

def updateFlake []: nothing -> nothing {
    log msg "Updating Flake"
  nix flake update --commit-lock-file
}

def "log msg" [
  msg: string
  color?: string
]: nothing -> nothing {
  let colorReal = (
    if ($color == null) {
      "blue"
    } else {
      $color
    }
  )
  print $"(ansi $colorReal)>>> ($msg)(ansi reset)"
}

def main [
  updateBlockProto: string
  attrFilter?: string
  --flake(-f) # Updates the flake in addition to updating packages
  --flake-only(-o) # Only updates the flake
] {
  if $flake_only {
    updateFlake
  } else {
    $updateBlockProto
    | from json
    | where { |updateBlock|
      if ($attrFilter != null) {
        $updateBlock.attrPath | str starts-with $attrFilter
      } else {
        true
      }
    }
    | each { |updateBlock|
      log msg $"Updating ($updateBlock.attrPath)"
      run-external ...($updateBlock.command)
    }
    if $flake {
      updateFlake
    }
  }
}
