const kpxcDatabaseArgs = [ -y 1 --no-password ]

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
  --flatten (-f)
  group?: string
] {
  mut args = []
  if ($group != null) {
    $args ++= [ $group ]
  }
  if $recursive {
    $args ++= [ --recursive ]
  }
  if $flatten {
    $args ++= [ --flatten ]
  }
  kpRaw ls ...$args
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
] {
  mut args = []
  if ($timeout != null) {
    $args ++= [ $timeout ]
  }
  if $best_match {
    $args ++= [ --best-match ]
  }
  kpRaw clip $entry ...$args
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