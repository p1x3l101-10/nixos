use base.nu *

export def "main" [
  entry: string@"nu-complete keepassxc entries"
  timeout?: int
  --best-match (-b)
  --totp (-t)
  --attribute (-a): string
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