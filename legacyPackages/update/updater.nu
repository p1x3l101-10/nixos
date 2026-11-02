#!/usr/bin/env nu

def main [
  updateBlockProto: string
  --flake(-f)
] {
  $updateBlockProto
  | from json
  | each { |updateBlock|
    print $"(ansi blue)>>> Updating ($updateBlock.attrPath)(ansi reset)"
    run-external ...($updateBlock.command)
  }
  if $flake {
    ^nix flake update --commit-lock-file
  }
}
