use base.nu *

# Generate a new random password.
export def "main" [
  --length (-L): int # Length of the generated password
  --lower (-l) # Use lowercase characters
  --upper (-U) # Use uppercase characters
  --numeric (-n) # Use numbers
  --special (-s) # Use special characters
  --extended (-e) # Use extended ASCII
  --exclude (-x): string # Exclude character set
  --exclude-similar # Exclude similar looking characters
  --every-group # Include characters from every selected group
  --custom (-c): string # Use custom character set
] {
  mut args = []
  if ($length != null) {
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