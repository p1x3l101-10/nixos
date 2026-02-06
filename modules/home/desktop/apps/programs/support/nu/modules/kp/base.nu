export const kpxcDatabaseArgs = [ -y 1 --no-password ]
export const entryColors = {
  Group: (ansi blue)
  Entry: (ansi green)
  reset: (ansi reset)
}

export def "kpRaw" [operation:string ...args] {
  let dbPath = $'($env.HOME)/Sync/Keepass/keepass.kdbx'
  ^keepassxc-cli $operation ...$kpxcDatabaseArgs $dbPath ...$args
}