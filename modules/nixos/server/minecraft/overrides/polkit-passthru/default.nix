{ ... }:

# Allow users in group "wheel" to manage the minecraft server without interferance
# Note: This will increase the attack surface, but I wanted convenience, and its just a minecraft server in a docker container
{
  security.polkit.extraConfig = builtins.readFile ./passwordless-management.rules;
}
