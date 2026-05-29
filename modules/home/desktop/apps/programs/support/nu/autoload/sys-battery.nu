const osType = $nu.os-info.name

def getValue [ name: string ] {
  where $it =~ $"($name):" | first | str replace $"($name):" "" | str trim
}

def processTime [] {
  str replace " hours" "hr"
  | str replace " hour" "hr"
  | str replace " minutes" "min"
  | str replace " minute" "min"
  | str replace " days" "day"
  | str replace " day" "day"
}

# Get information on attached batteries
export def "sys battery" [ --all ] {
  upower -e | lines
  | where { str contains BAT }
  | each { upower -i $in }
  | each { |x|
    let info = ($x | lines)
    {
      name: ($info | getValue native-path)
      updated: ($info | getValue updated | str replace -r '[A-Z]{3} \(.*\)' "" | into datetime)
      percentage: ($info | getValue percentage)
      capacity: ($info | getValue capacity)
      state: ($info | getValue state)
      time-to-empty: ($info | getValue "time to empty" | processTime)
      energy: ($info | getValue energy)
      energy-empty: ($info | getValue energy-empty)
      energy-full: ($info | getValue energy-full)
      voltage: ($info | getValue voltage)
      charge-cycles: ($info | getValue charge-cycles | into int)
      capacity-level: ($info | getValue capacity-level)
    }
    | (
      if ($all) {
        $in
      } else {
        $in
        | reject energy-full energy-empty energy voltage capacity-level charge-cycles updated
      }
    )
  }
  | (
    if ((($in | length) <= 1)) {
      if (($in | length) == 0) {
        "No batteries attached"
      } else {
        $in | first | (
          if ($all) {
            $in
          } else {
            reject name
          }
        )
      }
    } else {
      $in
    }
  )
}
