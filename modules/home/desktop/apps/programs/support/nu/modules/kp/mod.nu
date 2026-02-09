# keepassxc-cli wrapper that requires a yubikey and no password

export-env {
  $env.KEEPASSXC_DATABASE_PATH = ($env.HOME | path join "Sync/Keepass/keepass.kdbx")
}

export use add.nu
export use analyze.nu
export use clip-all.nu
export use clip.nu
export use db.nu
export use diceware.nu
export alias dw = diceware
export use edit.nu
export use estimate-entry.nu
export use estimate.nu
export use generate.nu
export alias gen = generate
export use ls.nu
export use show.nu
export use simple.nu *

# Simple wrapper that runs `help modules kp`
export def main [] {
  help modules kp
}