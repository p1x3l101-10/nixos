use base.nu *
use completions/item.nu *
use estimate.nu
use show.nu

def estimate-wrapper [
  password: string
  advanced: bool
] {
  if $advanced {
    estimate --advanced $password
  } else {
    estimate $password
  }
}

export def "main" [
  entry: string@"nu-complete keepassxc entries" # Path of the entry that will have it's password analized.
  --advanced (-a) # Perform advanced analysis on the password.
] {
  show $entry --show-protected
  | get Password
  | estimate-wrapper $in $advanced
}