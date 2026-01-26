{ pkgs, lib, config, ... }:

let
  inherit (config.lib.nushell) mkNushellInline;
in {
  programs.nushell = {
    enable = true;
    settings = {
      use_kitty_protocol = true;
      show_banner = false;
      completions.external = {
        enable = true;
        max_results = 100;
        completer = mkNushellInline "{|spans| carapace $spans.0 nushell ...$spans | from json }";
      };
    };
    extraConfig = ''
      const NU_LIB_DIRS = [
        ($nu.default-config-dir | path join 'modules')
        ($nu.default-config-dir | path join 'scripts')
        ($nu.data-dir | path join 'completions')
      ]

      # Import modules
      use filesystem/bm
      use filesystem/expand
      use jc
      use nix/nix
      use nix/nufetch
    '';
  };
  # Autoload
  xdg.configFile."nushell/autoload" = {
    source = ./support/nu/autoload;
    recursive = true;
  };
  xdg.configFile."nushell/modules" = {
    source = ./support/nu/modules;
    recursive = true;
  };
  xdg.configFile."nushell/scripts" = {
    source = ./support/nu/scripts;
    recursive = true;
  };
  # External completions
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
  # Integrations
  services.ssh-agent.enableNushellIntegration = true;
  services.gpg-agent.enableNushellIntegration = true;
  programs.starship.enableNushellIntegration = true;
  programs.zoxide.enableNushellIntegration = true;
  programs.nix-index.enableNushellIntegration = true;
  programs.lazygit.enableNushellIntegration = true;
  home.packages = [
    pkgs.jc
  ];

  # Actication script
  nix.settings.experimental-features = ["nix-command"];

  system.activationScripts.diff = ''
    if [[ -e /run/current-system ]]; then
      ${pkgs.nushell}/bin/nu -c "let diff_closure = (${pkgs.nix}/bin/nix store diff-closures /run/current-system '$systemConfig'); let table = (\$diff_closure | lines | where \$it =~ KiB | where \$it =~ → | parse -r '^(?<Package>\S+): (?<Old>[^,]+)(?:.*) → (?<New>[^,]+)(?:.*), (?<DiffBin>.*)$' | insert Diff { get DiffBin | ansi strip | into filesize } | sort-by -r Diff | reject DiffBin); if (\$table | get Diff | is-not-empty) { print \"\"; \$table | append [[Package Old New Diff]; [\"\" \"\" \"\" \"\"]] | append [[Package Old New Diff]; [\"\" \"\" \"Total:\" (\$table | get Diff | math sum) ]] | print; print \"\" }"
    fi
  '';
}
