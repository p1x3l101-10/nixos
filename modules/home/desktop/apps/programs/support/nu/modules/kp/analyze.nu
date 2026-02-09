use base.nu

# Analyze passwords for weaknesses and problems.
export def "main" [
  --hibp (-H): string # Check if any passwords have been publicly leaked. FILENAME must be the path of a file listing SHA-1 hashes of leaked passwords in HIBP format, as available from https://haveibeenpwned.com/Passwords.
] {
  mut args = []
  if ($hibp != null) {
    let okon_candidates = (which okon)
    let okon = (
      if ($okon_candidates == []) {
        null
      } else {
        $okon_candidates.0.path
      }
    )
    $args ++= [ --hibp $hibp ]
    if ($okon != null) {
      $args ++= [ --okon $okon ]
    }
  }
  kpRaw analyze ...$args
}