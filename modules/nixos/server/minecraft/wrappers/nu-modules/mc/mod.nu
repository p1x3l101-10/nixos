export def rcon [...cmd] {
  if ($cmd | is-empty) {
    sudo podman exec -it minecraft rcon-cli 
  } else {
    sudo podman exec minecraft rcon-cli ($cmd | str-join " ")
  }
}

export def log [
  --follow(-f)
  ...args
] {
  if ($follow) {
    journalctl -xefu minecraft ...$args
  } else {
    journalctl -xeu minecraft ...$args
  }
}

export module service {
  def service [
    operation: string
    blocking?
  ] {
    mut args = [ $operation ]
    if (not $blocking) {
      $args = $args ++ [ "--no-block" ]
    }
    sudo systemctl ...$args minecraft
  }
  export def restart [--no-block(-n)] {
    service restart $no_block
  }
  export def start [--no-block(-n)] {
    service "start" $no_block
  }
  export def stop [--no-block(-n)] {
    service stop $no_block
  }
}
