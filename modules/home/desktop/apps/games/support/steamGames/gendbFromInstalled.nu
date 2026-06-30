#!/usr/bin/env nu

let steamDir = $nu.home-dir | path join ".steam/root/steamapps"

def main [] {
  open ($steamDir | path join "libraryfolders.vdf")
  | get libraryfolders."0".apps
  | transpose
  | get column0
  | each { |x|
    open ($steamDir | path join $"appmanifest_($x).acf")
  }
  | get AppState
  | each { |x|
    $x
    | select appid name
  }
  | to json
  | save -f ./steamGameDb.json
}

export def "from vdf" []: string -> record {
  $in 
  | lines 
  | str trim 
  | str replace -r '(".*")\s+(".*")' '${1}: ${2}' 
  | str join "\n" 
  | str replace --all --multiline '^(".*").*\n(\{)$' '${1}: {' 
  | $"{($in)}" 
  | from json
}

export def "from acf" []: string -> record {
  from vdf
}
