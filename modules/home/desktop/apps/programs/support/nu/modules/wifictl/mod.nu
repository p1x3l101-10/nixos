# Wrapper around iwctl to fix my grievances

def cacheData [type: string, specifiers?: string] {
  let pipelineIn = $in
  let basePath = $env.XDG_CACHE_HOME | path join "wifictl"
  mkdir $basePath
  let cachePath = (
    $basePath | path join (if ($specifiers != null) {
      $'($type)-($specifiers).nuon'
    } else {
      $'($type).nuon'
    })
  )
  if ($cachePath | path exists) {
    if ((ls $cachePath | get modified | get 0) >= ((date now) - 1min)) {
      rm $cachePath
      $pipelineIn | to nuon | save $cachePath
    } else {}
  }
}

export def list-devices [] {
  iwctl station list
  | ansi strip
  | lines
  | skip 4
  | str trim
  | split column ' ' --collapse-empty station status
}
export alias devices = list-devices

def "nu-complete iwd stations" [] {
  list-devices
  | get station
}

export def scan [ station: string@"nu-complete iwd stations" ] {
  iwctl station $station scan
}


def rssi-to-glyphs [ dbm: int ] {
  const rssiQualities = [
    [minVal, glyph];
    [-50  "󰤨"]
    [-60  "󰤥"]
    [-70  "󰤢"]
    [-80  "󰤟"]
    [-90  "󰤠"]
    [-100 "󰤮"]
  ]
  $rssiQualities
  | where { |x| $x.minVal < $dbm }
  | first
  | get glyph
}

export def list-networks [
  station: string@"nu-complete iwd stations"
  --raw
] {
  scan $station
  iwctl station $station get-networks rssi-dbms
  | ansi strip
  | lines
  | skip 4
  | drop 1
  | str trim
  | par-each { |x|
    $x
    | sed -E -r 's/(.+)\b\s\s+([a-Z]+)\s+(-[0-9]+)/\1@@\2@@\3/'
  }
  | split column '@@'
  | each { |x| {
    name: $x.column0
    security: $x.column1
    strength: ($x.column2 | into int)
  } }
  | sort-by strength -r
  | (
    if $raw {
      $in
    } else {
      each { |x| {
        name: $x.name
        security: $x.security
        # Ungodly processing to turn a float into an int
        strength: (rssi-to-glyphs (($x.strength / 100 + 0.25) | into string | split words | get 0 | $'-($in)' | into int))
      } }
    }
  )
}
export alias list = list-networks

def "nu-complete iwd networks" [context: string] {
  let station = $context | split row " " | get 2
  list-networks $station --raw
  | each { |x| $'`($x.name)`' }
}

export def connect [
  station: string@"nu-complete iwd stations"
  network: string@"nu-complete iwd networks"
] {
  systemd-ask-password  --id="iwctl:network-connection-password" $'Password for "($network)"'
  | iwctl station $station connect $network
}
