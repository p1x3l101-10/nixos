use base.nu *

# Generate a new random diceware passphrase.
export def "main" [
  --words (-W): int
  --word-list (-w): string
] {
  mut args = []
  if ($words != null) {
    $args ++= [ --words $words ]
  }
  if ($word_list != null) {
    $args ++= [ --word-list $word_list ]
  }
  ^keepassxc-cli diceware ...$args
}