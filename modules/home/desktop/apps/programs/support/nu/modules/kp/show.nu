use base.nu *

export def "main" [
  entry:string
  --show-protected (-s)
  --attributes (-a): list<string>
  --all
  --show-attachments
  --totp (-t)
] {
  mut args = []
  if $show_protected {
    $args ++= [ --show-protected ]
  }
  if $all {
    $args ++= [ --all ]
  }
  if $show_attachments {
    $args ++= [ --show-attachments ]
  }
  if ($attributes != null) {
    $args ++= (
      $attributes
      | each { |x| [ --attributes $x ] }
      | flatten
    )
  }
  if $totp {
    $args ++= [ --totp ]
  }
  kpRaw show $entry ...$args
}