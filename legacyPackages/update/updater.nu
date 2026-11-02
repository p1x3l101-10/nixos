#!/usr/bin/env nu

def main [
  updateBlockProto: string
  attrFilter?: string
  --flake(-f)
] {
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
    print $"(ansi blue)>>> Updating ($updateBlock.attrPath)(ansi reset)"
    run-external ...($updateBlock.command)
  }
  if $flake {
    ^nix flake update --commit-lock-file
  }
}
