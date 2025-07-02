{ url
, key ? "signify RWRBgYcfobPE7I7STPLaQnp69F06aqQaBSWk0AuUFKlUoCyE6VUZKxJv"
, unsupVersion ? "1.1.5"
, sha256 ? "sha256:08nhk4rnj367qlk0dasr06p9jgjng123si9c9fwd3m3l8lbp2675"
}:

[
  "-javaagent:${builtins.fetchurl {
    url = "https://git.sleeping.town/unascribed/unsup/releases/download/v${unsupVersion}/unsup-${unsupVersion}.jar";
    inherit sha256;
  }}"
  "-Dunsup.disableReconciliation=true"
  "-Dunsup.bootstrapUrl='${url}'"
  "-Dunsup.bootstrapKey='${key}'"
]