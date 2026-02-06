const kpxcDatabaseArgs = [ -y 1 --no-password ]
const entryColors = {
  Group: (ansi blue)
  Entry: (ansi white)
  reset: (ansi reset)
}

def "kpRaw" [operation:string ...args] {
  let dbPath = $'($env.HOME)/Sync/Keepass/keepass.kdbx'
  ^keepassxc-cli $operation ...$kpxcDatabaseArgs $dbPath ...$args
}

export def "open" [] {
  kpRaw open
}

export def "add" [entry:string ...args] {
  kpRaw add ...$args
}

export def "mv" [source:string destination:string] {
  kpRaw mv $source $destination
}

export def "ls" [
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

export def "generate" [
  --length (-L): int
  --lower (-l)
  --upper (-U)
  --numeric (-n)
  --special (-s)
  --extended (-e)
  --exclude (-x): string
  --exclude-similar
  --every-group
  --custom (-c): string
] {
  mut args = []
  if ($length != null)   {
    $args ++= [ --length $length ]
  }
  if $lower {
    $args ++= [ --lower ]
  }
  if $upper {
    $args ++= [ --upper ]
  }
  if $numeric {
    $args ++= [ --numeric ]
  }
  if $special {
    $args ++= [ --special ]
  }
  if $extended {
    $args ++= [ --extended ]
  }
  if ($exclude != null) {
    $args ++= [ --exclude $exclude ]
  }
  if $exclude_similar {
    $args ++= [ --exclude-similar ]
  }
  if $every_group {
    $args ++= [ --every-group ]
  }
  if ($custom != null) {
    $args ++= [ --custom $custom ]
  }
  ^keepassxc-cli generate ...$args
}
export alias gen = generate

export def "diceware" [
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
export alias dw = diceware

export def "mkdir" [group: string] {
  kpRaw $group
}

export def "show" [
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

export def "clip" [
  entry: string
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

def "await-input" [msg: string] {
  print $msg
  let key = (input listen --types [key])
  # Clear last line
  tput cuu1; tput el
}

export def "clip-all" [
  entry: string
  --timeout (-T): int
  --totp (-t)
  --no-username (-u)
] {
  mut expireTime = 10
  if ($timeout != null) {
    $expireTime = $timeout
  }
  if (not $no_username) {
    await-input "Press any key to copy UserName"
    clip $entry $expireTime --attribute UserName
  }
  await-input "Press any key to copy Password"
  clip $entry $expireTime --attribute Password
  if $totp {
    await-input "Press any key to copy totp (Verification Code)"
    clip $entry $expireTime --totp
  }
}

export def "search" [term: string] {
  kpRaw search $term
}

export def "rmdir" [group: string] {
  kpRaw rmdir $group
}

export def "analyze" [
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
