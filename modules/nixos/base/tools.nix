{ pkgs, ... }:

{
  services.nixos-cli = {
    enable = true;
    useActivationInterface = true;
    config = {
      aliases = {
        genlist = [ "generation" "list" ];
        switch = [ "generation" "activate" ];
        rollback = [ "generation" "rollback" ];
        testcfg = [ "apply" "--no-boot" "--no-activate" ];
        build = [ "apply" "--no-boot" "--no-activate" "--output" "./result" ];
      };
      confirmation.empty = "default-yes";
      use_nvd = true;
      root_command = "run0";
      apply = {
        use_nom = true;
        reexec_as_root = true;
        use_git_commit_msg = true;
      };
    };
  };
  environment.systemPackages = with pkgs; [
    optnix
    nix-fast-build
    nix-output-monitor
    nix-eval-jobs
    nvd
  ];
}
