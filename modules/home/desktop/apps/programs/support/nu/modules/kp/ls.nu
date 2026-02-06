use base.nu *

export def "main" [
  --recursive (-R)
  group?: string
] {
  mut args = []
  if ($group != null) {
    $args ++= [ $group ]
  }
  if $recursive {
    $args ++= [ --recursive --flatten ]
  }
  kpRaw ls ...$args
  | lines
  | each { |x|
    mut name = ($x | str trim)
    let lastChar = ($name | split chars | last 1).0
    mut type = "Entry"
    mut color = $entryColors.Entry
    if ($lastChar == "/") {
      $name = ($name | str substring 0..-2)
      $type = "Group"
      $color = $entryColors.Group
    }
    {
      name: $'($color)($name)($entryColors.reset)'
      type: $type
    }
  }
  | where { |x|
    not ($x.name | str contains '[empty]')
  }
}