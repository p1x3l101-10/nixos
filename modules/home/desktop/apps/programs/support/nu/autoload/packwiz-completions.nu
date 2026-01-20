def "nu-complete-gen-options" [] {
  lines
  | where { str starts-with "  " }
  | where { |x| not ($x | str starts-with "      --") }
  | where { |x| not ($x | str starts-with "  -") }
  | parse "  {value} {description}"
  | str trim
}

def "nu-complete-gen-flags" [] {
  lines
  | where { str starts-with "  " }
  | where { |x| ($x | str starts-with "      --") }
  | where { |x| not ($x | str starts-with "  -") }
  | parse "      {value} {param} {description}"
  | str trim
  | select ...[value description]
}

def "nu-complete packwiz --" [] {
  ^packwiz --help | nu-complete-gen-flags
}

def "nu-complete packwiz" [] {
  ^packwiz --help | nu-complete-gen-options
}

export extern "packwiz" [
  command?: string@"nu-complete packwiz"
  flag?: string@"nu-complete packwiz --"
  --help(-h)
  --yes(-y)
]