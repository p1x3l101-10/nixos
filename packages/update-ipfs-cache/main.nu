#!/usr/bin/env nu

const nomDefault = true
const ipnsLifetime = "2d"
let workDir = mktemp --directory

export-env {
  if (which nom) != [] {
    $env.HAS_NOM = true
  } else {
    $env.HAS_NOM = false
  }
}

def useNom []: nothing -> bool {
  $env.HAS_NOM and ($env.USE_NOM? | default $nomDefault)
}

def --wrapped "nix build" [...args]: nothing -> nothing {
  if useNom {
    ^nom build ...$args
  } else {
    ^nix build ...$args
  }
}
def --wrapped "nix copy" [...args]: nothing -> nothing {
  if useNom {
    ^nom copy ...$args
  } else {
    ^nix build ...$args
  }
}

# A wrapper to ensure all the arguments I want are present, outputs the new CID hash
def --wrapped "ipfs add" [...args]: nothing -> string {
  ^ipfs add --hidden --dereference-symlinks --empty-dirs --wrap-with-directory --quieter ...$args
}

# Returns the CID of the new IPNS name
def --wrapped "ipfs publish" [...args]: nothing -> string {
  ^ipfs publish --quieter --lifetime $ipnsLifetime ...$args
}

def main [
  --flake(-f): string # Flake-ref to use instead of the default
  --no-nom # Forcefully disable Nix Output Monitor, even if installed (takes precedence over --use-nom)
  --use-nom # Forcefully enable Nix Output Monitor, despite the build defaults
]: nothing -> nothing {
  # Argument processing
  if $no_nom {
    $env.USE_NOM = false
  } else {
    if $use_nom {
      $env.USE_NOM = true
    }
  }
  if $flake == null {
    # Default flakeref
    $env.FLAKE_REF = "/etc/nixos#all-systems"
  } else {
    $env.FLAKE_REF = $flake
  }
  # Begin build
  cd $workDir
  nix build $env.FLAKE_REF
  mkdir narCache
  let narCacheAddr = [ "file://" ($workDir | path join narCache) ] | str join
  # Create the cache
  nix copy --to $narCacheAddr ($workDir | path join result)
  # Upload the cache
  let cid = ipfs add --recursive ./narCache/*
  # Make the cache findable
  let name = ipfs publish ("/ipfs" | path join $cid)
  # Cleanup
  cd $nu.temp-dir
  rm -rf $workDir
  # Finalize
  print ([ "Done, the cache can be found at this url: `" ("ipns://" | path join $name) "`" ] | str join)
}
