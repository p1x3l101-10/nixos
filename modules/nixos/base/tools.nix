{ pkgs, ... }:

{
  services.nixos-cli = {
    enable = true;
    useActivationInterface = true;
    settings = {
      aliases = {
        genlist = [ "generation" "list" ];
        switch = [ "generation" "activate" ];
        rollback = [ "generation" "rollback" ];
        testcfg = [ "apply" "--no-boot" "--no-activate" ];
        build = [ "apply" "--no-boot" "--no-activate" "--output" "./result" ];
      };
      confirmation.empty = "default-yes";
    };
  };
  environment.systemPackages = with pkgs; [
    optnix
    nix-fast-build
    nix-output-monitor
    nix-eval-jobs
  ];
}
