{ globals, ... }:

let
  inherit (globals.dirs) keys;
in {
  mailserver = {
    dkimKeyBits = 4096;
    dkimKeyDirectory = "${keys}/email/dkim";
    dkimSigning = true;
  };
}
