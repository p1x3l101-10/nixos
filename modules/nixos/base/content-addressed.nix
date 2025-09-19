{ ... }:
{
  nix.settings = {
    experimental-features = [ "ca-derivations" ];
    #substituters = [ "https://cache.ngi0.nixos.org" ];
    #trusted-public-keys = [ "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA=" ];
  };
}
