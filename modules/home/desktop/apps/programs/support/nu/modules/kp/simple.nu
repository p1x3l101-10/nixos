use base.nu *
use completions/item.nu *

export def "open" [] {
  kpRaw open
}

export def "add" [
  entry: string@"nu-complete keepassxc entries"
  ...args
] {
  kpRaw add ...$args
}

export def "mv" [
  source: string@"nu-complete keepassxc entries"
  destination: string@"nu-complete keepassxc items"
] {
  kpRaw mv $source $destination
}

export def "mkdir" [
  group: string@"nu-complete keepassxc groups"
] {
  kpRaw $group
}

export def "search" [term: string] {
  kpRaw search $term
}

export def "rmdir" [
  group: string@"nu-complete keepassxc groups"
] {
  kpRaw rmdir $group
}