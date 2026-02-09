use base.nu *
use completions/item.nu *
use clip.nu

def "await-input" [msg: string] {
  print $msg
  let key = (input listen --types [key])
  # Clear last line
  tput cuu1; tput el
}

# Copy an entry's attributes to the clipboard in order.
# The order is UserName, Password, TOTP
export def "main" [
  entry: string@"nu-complete keepassxc entries"
  --timeout (-T): int
  --totp (-t)
  --no-username (-u)
] {
  mut expireTime = 10
  if ($timeout != null) {
    $expireTime = $timeout
  }
  if (not $no_username) {
    await-input "Press any key to copy UserName"
    clip $entry $expireTime --attribute UserName
  }
  await-input "Press any key to copy Password"
  clip $entry $expireTime --attribute Password
  if $totp {
    await-input "Press any key to copy totp (Verification Code)"
    clip $entry $expireTime --totp
  }
}