# Estimate the entropy of a password.
export def "main" [
  password: string # Password for which to estimate the entropy.
  --advanced (-a) # Perform advanced analysis on the password.
] {
  mut args = []
  if $advanced {
    $args ++= [ --advanced ]
  }
  let out = (
    ^keepassxc-cli estimate ...$args $password
    | lines
  )
  let header = (
    $out.0
    | split words
    | {
      Length: ($in.1 | into int)
      Entropy: ($'($in.3).($in.4)' | into float)
      Log10: ($'($in.6).($in.7)' | into float)
    }
  )
  if (not $advanced) {
    print $header
    return
  }
  let extraBits = (
    $out.1
    | str trim
    | split words
    | {
      "Multi-word extra bits": $'($in.4).($in.5)'
    }
  )
  let advancedInfo = (
    $out
    | skip 2
    | str trim
    | each { |x|
      $x
      | split words
      | {
        Type: ($in.1)
        Length: ($in.3 | into int)
        Entropy: ($'($in.5).($in.6)' | into float)
        Argument: (
          if (($in | length) == 9) {
            null
          } else {
            $x
            | split words
            | skip 9
            | str join " "
          }
        )
      }
    }
  )
  {
    ...$header
    Advanced: {
      ...$extraBits
      Components: $advancedInfo
    }
  }
}