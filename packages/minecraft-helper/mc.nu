#!/usr/bin/env nu

const self = path self

def --wrapped elevate [...cmd] {
  if (is-admin) {
    run-external ...$cmd
  } else {
    run-external ...([ run0 ] ++ $cmd)
  }
}

def wrapString []: string -> string {
  str replace "'" '"'
  | [ "'" $in "'" ]
  | str join
}

def protectEval []: string -> string {
  [ '"' $in '"' ]
  | str join
}

def systemdTime []: duration -> string {
  into string
  | $"+($in)"
  | str replace "wk" "week" # Special case
  | str replace --regex '\s[0-9]+ns' "" # Systemd does not support nanoseconds
}

def processRconCommand []: list<string> -> string {
  each { |x|
    if ($x | str contains " ") {
      $x | protectEval
    } else {
      $x
    }
  }
  | str join " "
  | wrapString
}

def --wrapped "main log" [
  ...args
] {
  journalctl -Wxeu minecraft ...$args
}

def "main start" [
  --at: datetime
  --after: duration
] {
  if (($at == null) and ($after == null)) {
    elevate systemctl start minecraft --no-block
  } else {
    if ($after != null) {
      let at = (date now) + $after
      elevate systemctl start minecraft --when ($at | format date "%+") --no-block
    } else {
      elevate systemctl start minecraft --when ($at | format date "%+") --no-block
    }
  }
}

def "main stop" [
  --at: datetime
  --after: duration
] {
  if (($at == null) and ($after == null)) {
    elevate systemctl stop minecraft --no-block
  } else {
    if ($after != null) {
      let at = (date now) + $after
      main rcon say ([ "Server will stop " ($at | date humanize) ] | str join)
      if (($at - (date now)) > 10min) {
        main rcon say "Server will stop in 5 minutes" --at ($at - 5min)
        main rcon say "Server will stop in 1 minute" --at ($at - 1min)
      }
      elevate systemctl stop minecraft --when ($at | format date "%+") --no-block
    } else {
      main rcon say ([ "Server will stop " ($at | date humanize) ] | str join)
      if (($at - (date now)) > 10min) {
        main rcon say "Server will stop in 5 minutes" --at ($at - 5min)
        main rcon say "Server will stop in 1 minute" --at ($at - 1min)
      }
      elevate systemctl stop minecraft --when ($at | format date "%+") --no-block
    }
  }
}

def "main restart" [
  --at: datetime
  --after: duration
] {
  if (($at == null) and ($after == null)) {
    elevate systemctl restart minecraft --no-block
  } else {
    if ($after != null) {
      let at = (date now) + $after
      main rcon say ([ "Server is queued for a restart " ($at | date humanize) ] | str join)
      if (($at - (date now)) > 10min) {
        main rcon say "Server will restart in 5 minutes" --at ($at - 5min)
        main rcon say "Server will restart in 1 minute" --at ($at - 1min)
      }
      elevate systemctl restart minecraft --when ($at | format date "%+") --no-block
    } else {
      main rcon say ([ "Server is queued for a restart " ($at | date humanize) ] | str join)
      if (($at - (date now)) > 10min) {
        main rcon say "Server will restart in 5 minutes" --at ($at - 5min)
        main rcon say "Server will restart in 1 minute" --at ($at - 1min)
      }
      elevate systemctl restart minecraft --when ($at | format date "%+") --no-block
    }
  }
}

def "main rcon" [
  --at: datetime
  --after: duration
  ...command
] {
  if (($at == null) and ($after == null)) {
    if ($command == []) {
      elevate podman exec -it minecraft rcon-cli
    } else {
      elevate podman exec -it minecraft rcon-cli ($command | processRconCommand)
    }
  } else {
    if ($command == []) {
      error make {
        msg: "Delay cannot be specified without command to run"
        label: {
          text: "Must have command in body"
          span: (metadata $command | get span)
        }
      }
    } else {
      if ($after == null) {
        elevate systemd-run --on-calendar ($at | format date "%+") podman exec -it minecraft rcon-cli ($command | processRconCommand)
      } else {
        let at = (date now) + $after
        elevate systemd-run --on-calendar ($at | format date "%+") podman exec -it minecraft rcon-cli ($command | processRconCommand)
      }
    }
  }
}

def main [] {
  print "This program only has subcommands, please see the help page (re-run with `--help` as an argument)"
  exit 1
}
