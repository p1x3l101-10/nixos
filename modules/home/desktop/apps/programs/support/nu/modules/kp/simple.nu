use base.nu *
use completions/item.nu *

# Open a database to an interactive CLI.
export def "open" [] {
  kpRaw open
}

# Add a new entry to a database.
export def "add" [
  entry: string@"nu-complete keepassxc entries" # Path of the entry to add.
  ...args
] {
  kpRaw add ...$args
}

# Moves an entry to a new group.
export def "mv" [
  source: string@"nu-complete keepassxc entries" # Path of the entry to move.
  destination: string@"nu-complete keepassxc items" # Path of the destination group.
] {
  kpRaw mv $source $destination
}

# Adds a new group to a database.
export def "mkdir" [
  group: string@"nu-complete keepassxc groups" # Path of the group to add.
] {
  kpRaw $group
}

# Find entries quickly.
export def "search" [term: string] {
  kpRaw search $term
}

# Removes a group from a database.
export def "rmdir" [
  group: string@"nu-complete keepassxc groups" # Search term.
] {
  kpRaw rmdir $group
}

# Remove an entry from the database.
export def "rm" [
  entry: string@"nu-complete keepassxc entries" # Path of the entry to remove.
] {
  kpRaw rm $entry
}