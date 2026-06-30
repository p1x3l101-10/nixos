const NU_LIB_DIRS = [
  ($nu.default-config-dir | path join 'modules')
  ($nu.default-config-dir | path join 'scripts')
  ($nu.data-dir | path join 'completions')
]

# Import modules
use filesystem/bm.nu
use filesystem/expand.nu
use jc
use nix/nix.nu
use nix/nufetch.nu
use kp
use wifictl
use clip
