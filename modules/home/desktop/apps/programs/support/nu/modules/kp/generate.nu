use base.nu *

# Generate a new random password.
export def "main" [
  --length (-L): int
  --lower (-l)
  --upper (-U)
  --numeric (-n)
  --special (-s)
  --extended (-e)
  --exclude (-x): string
  --exclude-similar
  --every-group
  --custom (-c): string
] {
  mut args = []
  if ($length != null)   {
    $args ++= [ --length $length ]
  }
  if $lower {
    $args ++= [ --lower ]
  }
  if $upper {
    $args ++= [ --upper ]
  }
  if $numeric {
    $args ++= [ --numeric ]
  }
  if $special {
    $args ++= [ --special ]
  }
  if $extended {
    $args ++= [ --extended ]
  }
  if ($exclude != null) {
    $args ++= [ --exclude $exclude ]
  }
  if $exclude_similar {
    $args ++= [ --exclude-similar ]
  }
  if $every_group {
    $args ++= [ --every-group ]
  }
  if ($custom != null) {
    $args ++= [ --custom $custom ]
  }
  ^keepassxc-cli generate ...$args
}