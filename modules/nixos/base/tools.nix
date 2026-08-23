{ pkgs, config, lib, ... }:

{
  programs.nixos-cli = {
    enable = true;
    activation-interface.enable = true;
    option-cache = {
      enable = lib.mkForce true;
      exclude = [
        # The legacy interface for an input is kinda broken due to legacy cruft building up
        # Normally, it evaluates fine, but traversing the option tree is not done safely, so just avoid it
        "nix-citizen" 
      ];
    };
    settings = {
      aliases = {
        genlist = [ "generation" "list" ];
        switch = [ "generation" "activate" ];
        rollback = [ "generation" "rollback" ];
        testcfg = [ "apply" "--no-boot" "--no-activate" ];
        build = [ "apply" "--no-boot" "--no-activate" "--output" "./result" ];
      };
      confirmation.empty = "default-yes";
      differ.command = [ "nvd" "diff" ];
      root = {
        command = "run0";
        password_method = "tty";
      };
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
