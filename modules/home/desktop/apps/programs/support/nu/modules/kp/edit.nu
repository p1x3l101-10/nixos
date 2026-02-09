use base.nu *
use completions/item.nu *

# Edit an entry.
export def "main" [
  entry: string@"nu-complete keepassxc entries" # Name of the entry to edit.
  --username (-u):string  # Username for the entry.
  --url:string # URL for the entry.
  --notes:string # Notes for the entry.
  --password-prompt (-p) # Prompt for the entry's password.
  --title (-t):string # Title for the entry.
  --generate (-g) # Generate a password for the entry.
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
  if ($username != null) {
    $args ++= [ --username $username ]
  }
  if ($url != null) {
    $args ++= [ --url $url ]
  }
  if ($notes != null) {
    $args ++= [ --notes $notes ]
  }
  if $password_prompt {
    $args ++= [ --password-prompt ]
  }
  if ($title != null) {
    $args ++= [ --title $title ]
  }
  if $generate {
    $args ++= [ --generate ]
  }
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

  kpRaw edit $entry ...$args
}