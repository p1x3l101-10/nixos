# Commands for interacting with the system clipboard
#
# > Currently supported clipboards are Wayland

def getClipType []: nothing -> string {
  match $nu.os-info.name {
    "linux" => (
        match $env.XDG_SESSION_TYPE {
          "wayland" => "linux-wayland"
        }
      )
    _ => (error make "Unable to find a supported clipboard type")
  }
}

# Copy input to system clipboard
export def copy [
  --ansi(-a) # Copy ansi formatting
]: any -> nothing {
  let input = $in | collect
  let text = match ($input | describe -d | get type) {
    $type if $type in [ table, record, list ] => {
      $input | table -e
    }
    _ => {$input}
  }

  let strip = match $ansi {
    true  => ({||})
    false => ({|| ansi strip})
  }

  let sysClip = match (getClipType) {
    "linux-wayland" => ({|x| wl-copy $x})
  }
  do $sysClip ($text | do $strip)
}

# Paste contenst of system clipboard
export def paste []: nothing -> string {
  let sysClip = match (getClipType) {
    "linux-wayland" => ({|| wl-paste -no-newline})
  }
  do $sysClip
}
