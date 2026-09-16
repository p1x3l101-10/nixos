def filterGpu [ gpuFull: string ]: string -> string {
  let cpuFull = $in
  let gpuName = $in | str replace "AMD " ""
  if ($cpuFull | str contains $gpuName) {
    return (
      $cpuFull | str replace $gpuName "" | str replace "w/" "" | str trim
    )
  } else {
    return $cpuFull
  }
}

export def main [] { 
  let host = sys host
  let gpu = (nix shell nixpkgs#mesa-demos --command glxinfo | lines | where { str contains "Device:" } | str trim | get 0 | str replace "Device: " "" | str replace --all --regex '^(.*?) \(.*\)$' "${1}")
  {
    nu: $env.NU_VERSION
    hardware: {
      cpu: (sys cpu | get 0.brand | filterGpu $gpu | [ $in " (" (sys cpu | length) ")"] | str join "")
      gpu: $gpu
      ram: (sys mem | select total free used)
      disk: {
        esp: (sys disks | where $it.mount == /efi | get 0 | select total free type | {
          type: $in.type
          total: $in.total
          free: $in.free
          used: ($in.total - $in.free)
        })
        nix: (sys disks | where $it.mount == /nix | get 0 | select total free type | {
          type: $in.type
          total: $in.total
          free: $in.free
          used: ($in.total - $in.free)
        })
        swap: (sys mem | {
          type: "swap"
          total: $in."swap total"
          free: $in."swap free"
          used: $in."swap used"
        })
      }
    }
    os: {
      kernel: $nu.os-info.kernel_version
      arch: $nu.os-info.arch
      name: $host.name
      version: $host.os_version
      uptime: $host.uptime 
      age: ((date now) - (ls -laD /nix/host | get 0.created) | format duration day | $"($in)s")
      packages: (ls /etc/profiles/per-user | select name | prepend [[name];["/run/current-system/sw"]] | each { insert "number" (nix path-info --recursive ($in | get name) | lines | length) | insert "size" ( nix path-info -S ($in | get name) | parse -r '\s(.*)' | get capture0.0 | into filesize) | update "name" ($in | get name | parse -r '.*/(.*)' | get capture0.0 | if $in == "sw" {"system"} else {$in}) | rename "environment"})
    }
  }
}
