{ ... }:

{
  systemd.network.networks."50-wg0".address = [
    "10.64.186.61/32"
    "fd2a:bf8f:acb9::/64"
  ];
}
