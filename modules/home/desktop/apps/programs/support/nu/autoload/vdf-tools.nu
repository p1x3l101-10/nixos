export def "from vdf" []: string -> record {
  $in 
  | lines 
  | str trim 
  | str replace -r '(".*")\s+(".*")' '${1}: ${2}' 
  | str join "\n" 
  | str replace --all --multiline '^(".*").*\n(\{)$' '${1}: {' 
  | $"{($in)}" 
  | from json
}
