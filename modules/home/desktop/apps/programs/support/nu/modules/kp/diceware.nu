use base.nu *

# Generate a new random diceware passphrase.
export def "main" [
  --words (-W): int # Word count for the diceware passphrase.
  --word-list (-w): string # Wordlist for the diceware generator. [Default: EFF English]
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