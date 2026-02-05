export def "open" [] {
  ^keepassxc-cli open -y 1 --no-password $'($env.HOME)/Sync/Keepass/keepass.kdbx'
}
