{ lib, ... }:

{
  # Override to correct netdev
  systemd.network.networks."10-wired".name = "enp2s0";
}
