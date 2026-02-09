use base.nu *

export def "info" [] {
  kpRaw db-info
}

# No more subcommands, as they dont really change much for me