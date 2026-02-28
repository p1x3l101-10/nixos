# Wrapper around iwctl to fix my grievances

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
  | where { |x| $x.minVal > $dbm }
  | last
  | get glyph
}

export def list-networks [
  station: string@"nu-complete iwd stations"
  --raw
] {
  scan $station
  let rawData = (
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
  )
  if $raw {
    $rawData
    return
  }
  $rawData
  | { |x| {
    name: $x.name
    security: $x.security
    strength: (rssi-to-glyphs ($x.strength / 100))
  } }
}
export alias list = list-networks

def "nu-complete iwd networks" [context: string] {
  let station = $context | split row " " | get 3
  list-networks $station
  | get name
}

export def connect [
  station: string@"nu-complete iwd stations"
  network: string@"nu-complete iwd networks"
] {
  systemd-ask-password  --id="iwctl:network-connection-password" $'Password for "($network)"'
  | iwctl station $station connect $network
}
