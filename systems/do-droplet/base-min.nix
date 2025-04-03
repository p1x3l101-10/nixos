{ ... }:

let
  base = ../../modules/nixos/base;
in
{
  imports = [
    "${base}/base.nix"
    "${base}/cachix.nix"
    "${base}/locale.nix"
    "${base}/ssh.nix"
  ];
}