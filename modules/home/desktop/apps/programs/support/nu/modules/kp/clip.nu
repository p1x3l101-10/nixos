use base.nu *
use completions/item.nu *

# Copy an entry's attribute to the clipboard.
export def "main" [
  entry: string@"nu-complete keepassxc entries" # Path of the entry to clip.
  timeout?: int # Timeout before clearing the clipboard (default is 10 seconds, set to 0 for unlimited).
  --best-match (-b) # Must match only one entry, otherwise a list of possible matches is shown.
  --totp (-t) # Copy the current TOTP to the clipboard (equivalent to "-a totp").
  --attribute (-a): string # Copy the given attribute to the clipboard. Defaults to "password" if not specified.
] {
  mut args = []
  if ($timeout != null) {
    $args ++= [ $timeout ]
  }
  if $best_match {
    $args ++= [ --best-match ]
  }
  if $totp {
    $args ++= [ --totp ]
  }
  if ($attribute != null) {
    $args ++= [ --attribute $attribute ]
  }
  kpRaw clip $entry ...$args
}