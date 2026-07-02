{ pkgs, config, lib, ... }:

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
      rollback.enable = false;
    };
  };
  environment.systemPackages = with pkgs; [
    optnix
    nix-fast-build
    nix-output-monitor
    nix-eval-jobs
    nvd
    # Override run0 to not have a stupid color background
    ((writeShellScriptBin "run0" ''
      exec ${config.systemd.package}/bin/run0 --background="" "$@"
    '') // { meta.priority = 1; })
  ];
}
