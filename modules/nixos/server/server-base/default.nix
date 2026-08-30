{ pkgs, config, ... }:

{
  imports = [
    ./container.nix
    ./ip-block.nix
    #./nix.nix
    #./proxy.nix
    ./speed.nix
    ./ssh.nix
    ./user.nix
  ];
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "repo-update";
      runtimeInputs = with config; [
        programs.git.package
        programs.nixos-cli.package
      ];
      text = ''
        if [[ $UID != 1000 ]]; then
          systemd-run --uid=1000 "$(realpath $0)"
        else
          git -C /etc/nixos reset --hard
          git -C /etc/nixos pull
        fi
        if [[ $1 == "switch" ]]; then
          nixos apply -y
        fi
      '';
    })
  ];
}
