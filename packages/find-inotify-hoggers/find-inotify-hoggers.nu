#!/usr/bin/env nu

const script = path self

def main [] {
  if (not (is-admin)) {
    run0 $script
  }

  do -i { ls /proc/*/fdinfo/* }
  | where $it.type == file
  | each { |x|
    let components = ($x.name | split words)
    {
      pid: $components.1
      fd: $components.3
      inotifies: (
        if ($x.name | path exists) {
          open $x.name
          | lines
          | where { str contains inotify }
          | length
        } else {
          null
        }
      )
    }
  }
  | where { |it| ($it.inotifies != null) and ($it.inotifies > 0) }
  | sort-by inotifies
}
