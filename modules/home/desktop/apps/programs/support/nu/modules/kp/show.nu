use base.nu *
use completions/item.nu *

export def "main" [
  entry: string@"nu-complete keepassxc entries"
  --show-protected (-s)
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
  let rawRawOutput = (kpRaw show $entry ...$args)
  let linedOutput = ($rawRawOutput | lines)
  mut rawOutput = ""
  # Get keys
  mut hasKeys = false
  mut midKey = false
  mut keyPositions = []
  mut workingKey = {
    firstIdx: null
    lastIdx: null
  }
  for elt in ($linedOutput | enumerate) {
    if (($elt.item | str contains '-----BEGIN PRIVATE KEY-----') and (not $midKey)) {
      $hasKeys = true
      $midKey = true
      $workingKey.firstIdx = $elt.index
    }
    if (($elt.item | str contains '-----END PRIVATE KEY-----') and $midKey) {
      $midKey = false
      $workingKey.lastIdx = $elt.index
      $keyPositions ++= [ $workingKey ]
      $workingKey = {
        firstIdx: null
        lastIdx: null
      }
    }
  }
  if $hasKeys {
    mut workData = $linedOutput
    for y in $keyPositions {
      mut workStaged = ""
      mut workSaved = ""
      for x in $y.firstIdx..$y.lastIdx {
        if ($x == $y.firstIdx) {
          let work = (
            $linedOutput
            | get $x
            | split row ':'
          )
          $workStaged = ($work.0 + ": |")
          $workSaved = (
            $work.1
            | str replace ' ' ''
          )
        } else {
          $workStaged = "  " + $workSaved
          $workSaved = (
            $linedOutput
            | get $x
          )
        }
        $workStaged = ($workStaged)
        $workData = (
          $workData
          | update $x $workStaged
        )
      }
      $workData = (
        $workData
        | update ($y.lastIdx + 1) ( "  " + $workSaved)
      )
    }
    $rawOutput = ($workData | str join (char newline))
  } else {
    $rawOutput = $rawRawOutput
  }
  mut output = ($rawOutput | from yaml)
  $output.Uuid = (
    $output.Uuid
    | to yaml
    | str substring 0..-8
  )
  $output.Tags = (
    $output.Tags
    | split row ','
  )
  $output
}