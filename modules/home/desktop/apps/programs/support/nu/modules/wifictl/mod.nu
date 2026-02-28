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

export def list-networks [
  station: string@"nu-complete iwd stations"
] {
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
}
export alias list = list-networks

export def connect [
  station: string@"nu-complete iwd stations"
  network: string
] {
  systemd-ask-password  --id="iwctl:network-connection-password" $'Password for "($network)"'
  | iwctl station $station connect $network
}
