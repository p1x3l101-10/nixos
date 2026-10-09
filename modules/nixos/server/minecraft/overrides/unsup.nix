{ url
, key ? "signify RWRBgYcfobPE7I7STPLaQnp69F06aqQaBSWk0AuUFKlUoCyE6VUZKxJv"
, unsupVersion ? "1.2.7"
, sha256 ? "sha256:34483991b6bf218636d6769466faa5246901074bce731538147aa255cc046d59"
}:

[
  "-javaagent:${builtins.fetchurl {
    url = "https://git.sleeping.town/unascribed/unsup/releases/download/v${unsupVersion}/unsup-${unsupVersion}.jar";
    inherit sha256;
  }}"
  "-Dunsup.disableReconciliation=true"
  "-Dunsup.bootstrapUrl='${url}'"
  #"-Dunsup.bootstrapKey='${key}'"
]
