# Save a file, with polkit for privilage elevation
export def "run0 save" [
  --raw(-r), # save file as raw binary
  --append(-a), # append input to the end of the file
  --force(-f), # overwrite the destination file if it exists
  --progress(-p), # enable progress bar
  filename: path # The filename to use
]: any -> nothing {
  let flags = [
    (if $raw { "--raw" })
    (if $append { "--append" })
    (if $force { "--force" })
    (if $progress { "--progress" })
  ] | compact
  $in | run0 $nu.current-exe --stdin -c $"save ($flags | str join ' ') ($filename)"
}

# Save a file, with sudo for privilage elevation
export def "sudo save" [
  --raw(-r), # save file as raw binary
  --append(-a), # append input to the end of the file
  --force(-f), # overwrite the destination file if it exists
  --progress(-p), # enable progress bar
  filename: path # The filename to use
]: any -> nothing {
  let flags = [
    (if $raw { "--raw" })
    (if $append { "--append" })
    (if $force { "--force" })
    (if $progress { "--progress" })
  ] | compact
  $in | sudo $nu.current-exe --stdin -c $"save ($flags | str join ' ') ($filename)"
}
