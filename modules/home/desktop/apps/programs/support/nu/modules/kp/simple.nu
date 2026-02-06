use base.nu *

export def "open" [] {
  kpRaw open
}

export def "add" [entry:string ...args] {
  kpRaw add ...$args
}

export def "mv" [source:string destination:string] {
  kpRaw mv $source $destination
}

export def "mkdir" [group: string] {
  kpRaw $group
}

export def "search" [term: string] {
  kpRaw search $term
}

export def "rmdir" [group: string] {
  kpRaw rmdir $group
}