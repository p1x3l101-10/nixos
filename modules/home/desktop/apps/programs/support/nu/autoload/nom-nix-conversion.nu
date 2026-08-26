def --wrapped "nix build" [...args] { nom build ...$args }
def --wrapped "nix shell" [...args] { nom shell ...$args }
def --wrapped "nix develop" [...args] { nom develop ...$args }
def --wrapped "nix copy" [...args] { nom copy ...$args }
def --wrapped "nix flake" [...args] { nom flake ...$args }
