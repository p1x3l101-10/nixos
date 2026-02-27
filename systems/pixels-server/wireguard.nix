{ ... }:

{
  systemd.network.networks."50-wg0".address = [
    "10.64.186.60/32"
    "fd31:8b54:ccba::/64"
  ];
}
