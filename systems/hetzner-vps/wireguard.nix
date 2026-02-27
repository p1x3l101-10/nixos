{ ... }:

{
  systemd.network.networks."50-wg0".address = [
    "10.64.186.61/32"
    "fd31:8b54:ccba::acb9/64"
  ];
}
