{ lib
, writeShellScriptBin
, util-linux
, openssl
, efitools
, coreutils
}:

writeShellScriptBin "gen-sb-keys" ''
  echo -n "Enter a Common Name to embed in the keys: "
  read NAME

  ${coreutils}/bin/mkdir -p keys
  ${coreutils}/bin/mkdir -p keys/PK
  ${coreutils}/bin/mkdir -p keys/KEK
  ${coreutils}/bin/mkdir -p keys/db

  # generate new GUID
  ${util-linux}/bin/uuidgen --random > keys/GUID

  # Generate new keys and certificates
  ${openssl}/bin/openssl req -new -x509 -newkey rsa:2048 -subj "/CN=$NAME PK/"  -keyout keys/PK/PK.key   -out keys/PK/PK.crt   -days 3650 -nodes -sha256
  ${openssl}/bin/openssl req -new -x509 -newkey rsa:2048 -subj "/CN=$NAME KEK/" -keyout keys/KEK/KEK.key -out keys/KEK/KEK.crt -days 3650 -nodes -sha256
  ${openssl}/bin/openssl req -new -x509 -newkey rsa:2048 -subj "/CN=$NAME DB/"  -keyout keys/db/db.key   -out keys/db/db.crt   -days 3650 -nodes -sha256

  # PEM format, lzbt needs this
  ${openssl}/bin/openssl x509 -in keys/PK/PK.crt   -out keys/PK/PK.pem   -outform PEM
  ${openssl}/bin/openssl x509 -in keys/KEK/KEK.crt -out keys/KEK/KEK.pem -outform PEM
  ${openssl}/bin/openssl x509 -in keys/db/db.crt   -out keys/db/db.pem   -outform PEM

  # DER format
  ${openssl}/bin/openssl x509 -in keys/PK/PK.crt   -out keys/PK/PK.cer   -outform DER
  ${openssl}/bin/openssl x509 -in keys/KEK/KEK.crt -out keys/KEK/KEK.cer -outform DER
  ${openssl}/bin/openssl x509 -in keys/db/db.crt   -out keys/db/db.cer   -outform DER

  # EFI Signature List
  ${efitools}/bin/cert-to-efi-sig-list -g "$(< keys/GUID)" keys/PK/PK.crt   keys/PK/PK.esl
  ${efitools}/bin/cert-to-efi-sig-list -g "$(< keys/GUID)" keys/KEK/KEK.crt keys/KEK/KEK.esl
  ${efitools}/bin/cert-to-efi-sig-list -g "$(< keys/GUID)" keys/db/db.crt   keys/db/db.esl

  # Sign Keys
  ${efitools}/bin/sign-efi-sig-list -g "$(< keys/GUID)" -k keys/PK/PK.key   -c keys/PK/PK.crt   PK  keys/PK/PK.esl    keys/PK/PK.auth
  ${efitools}/bin/sign-efi-sig-list -g "$(< keys/GUID)" -k keys/PK/PK.key   -c keys/PK/PK.crt   KEK keys/KEK/KEK.esl  keys/KEK/KEK.auth
  ${efitools}/bin/sign-efi-sig-list -g "$(< keys/GUID)" -k keys/KEK/KEK.key -c keys/KEK/KEK.crt db  keys/db/db.esl    keys/db/db.auth

  # Sign an empty file to allow removing Platform Key when in "User Mode"
  ${efitools}/bin/sign-efi-sig-list -g "$(< keys/GUID)" -c keys/PK/PK.crt -k keys/PK/PK.key PK /dev/null keys/noPK.auth

''
