# Simple wrapper that runs `help modules printer``
export def main [] {
  help modules printer
}

# Open in print dialogue
export def dialogue [
  --title(-t): string
]: binary -> nothing {
  gdbus call --session --dest org.freedesktop.portal.Desktop --object-path /org/freedesktop/portal/desktop --method org.freedesktop.portal.Print.Print "" "Printing from NuShell" 0 "{'modal':<true>}"
}
