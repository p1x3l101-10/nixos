use base.nu

export def "main" [
  --hibp (-H): string
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