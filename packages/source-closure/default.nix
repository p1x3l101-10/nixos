{ lib
, writeShellScriptBin
, nix
, jq
, coreutils
}:

writeShellScriptBin "rebuild" ''
  # the nixpkgs etc. that are needed at evaluation time, all stored in the NIV json doc
  evaluationPaths=$(${nix}/bin/nix eval --strict --raw --expr "builtins.map builtins.toString (builtins.attrValues (import ./nix/sources.nix {}))" | ${jq}/bin/jq -r .[])

  # all source code tarballs that result from the set of derivations that is emitted by default.nix
  sourceClosurePaths=$(${nix}/bin/nix show-derivation -r $(nix eval --raw default.nix) | ${jq}/bin/jq -r 'to_entries[] | select(.value.outputs.out.hash != null) | .key' | ${coreutils}/bin/xargs nix-store -r)

  ${nix}/bin/nix store --export $evaluationPaths $sourceClosurePaths > all-source-tarballs.closure
''