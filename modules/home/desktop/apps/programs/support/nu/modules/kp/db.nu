use base.nu *

# Show a database's information.
export def "info" [] {
  kpRaw db-info
}

# No more subcommands, as they dont really change much for me