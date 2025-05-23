{ lib, ... }:

{
  # Override to correct netdev
  systemd.network.networks."10-wired".name = lib.mkForce "enp2s0";
}
