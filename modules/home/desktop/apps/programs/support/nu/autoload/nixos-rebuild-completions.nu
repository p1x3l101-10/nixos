def "nu-complete nixos-rebuild" [] {
  [
    switch
    boot
    test
    build
    edit
    repl
    dry-build
    dry-run
    dry-acticate
    build-image
    build-vm
    build-vm-with-bootloader
    list-generations
  ]
}

def "nu-complete nix log-format" [] {
  ['raw', 'internal-json', 'bar', 'bar-with-logs']
}

export extern "nixos-rebuild" [
  command: string@"nu-complete nixos-rebuild"
  --help
  --verbose
  --quiet
  --max-jobs: number
  --cores: number
  --log-format: string@'nu-complete nix log-format'
  --keep-going
  --keep-failed
  --fallback
  --repair
  --print-build-logs
  --show-trace
  --accept-flake-config
  --install-boot-loader
  --flake: string
  --no-flake
  --rollback
  --upgrade
  --upgrade-all
  --json
  --ask-sudo-password
  --sudo
]