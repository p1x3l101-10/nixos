use ../base.nu *

def "simple-ls" [] {
  kpRaw ls "--recursive" "--flatten"
  | lines
  | each { |x|
    mut name = ($x | str trim)
    mut type = "Entry"
    let lastChar = ($name | split chars | last 1).0
    if ($lastChar == "/") {
      $name = ($name | str substring 0..-2)
      $type = "Group"
    }
    {
      name: $name
      type: $type
    }
  }
  | where { |x|
    not ($x.name | str contains '[empty]')
  }
}

export def "nu-complete keepassxc entries" [] {
  simple-ls
  | where { |x| $x == "Entry" }
  | each { |x| $x.name }
}

export def "nu-complete keepassxc groups" [] {
  simple-ls
  | where { |x| $x == "Group" }
  | each { |x| $x.name }
}

export def "nu-complete keepassxc items" [] {
  simple-ls
  | each { |x| $x.name }
}