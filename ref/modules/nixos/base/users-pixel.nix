{ pkgs, config, ... }:
{
  users.users.pixel = {
    isNormalUser = true;
    description = "Pixel";
    extraGroups = [ "wheel" "networkManager" ];
    createHome = true;
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6lPSxvOjzW9MB6LpB3lo1vT8llUI74lnUyMDpeUtNyli2RAP4BWxCKADb2wz0OI4bIbjWMcKwelyOolja9xLPVwCfiYfqu8ir5mCaeItOKFH46TG1loBC07NugQYZKabKW8rVM4B6OA4y2HtI89RSzKrggCCPDj+K5yStzlq6E5jlrxiRjJmWNxz2G/HTH9qVuyAt1ppN6RXwJ04WdE/XbwSsbiRzuOujKV+anccPJg4XRaa0RZtrjcCwlv9ZVz01ftym+ur1C1lxoY48J85B2DEqlZt+sZrCtQgEm7RZg2C9DJRh8zioJ35FqY8NlDEcPhKeqgsKcuuLMrmUpx6XzpR8EvGF2vo5ButF/nw8rx3/RAr5JM5BXIaYGTueaqZuBH2TIXsp49BdkYZOkQps6YnGxPO+SuA4hKSEqY7aoUUwEWr50iefQzmMAYdxxqT8cDYe6ObzaQom4mEnNzb7J6YgOXT/IcfR+WmY3YPkTWuY85+eBeTZVzrIbtKEh68= pixel@pixels-pc" ];
  };
  nix.settings.trusted-users = [ "pixel" ];

  system.activationScripts = {
    fix-home.text = ''
      mkdir -p /home/pixel/.config/dconf
      mkdir -p /home/pixel/.cache/dconf
      chown -R pixel:users /home/pixel
    '';
  };

  # Add symlink from ~pixel/Projects/nixos-config to /etc/nixos
  environment.etc.nixos.source = "${config.users.users.pixel.home}/Projects/nixos-config";
  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };
  environment.systemPackages = [ pkgs.vim ];
}
