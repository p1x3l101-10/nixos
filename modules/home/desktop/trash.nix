{ pkgs, ... }:

{
  home.packages = with pkgs; [
    trashy
    fzf
  ];
  home.shellAliases = {
    rm = "trashy put";
    rm-force = "/run/current-system/sw/bin/rm";
    rm-list = "trashy list | fzf --multi | awk '{$1=$1;print}' | rev | cut -d ' ' -f1 | rev | xargs trashy restore --match=exact --force";
    rm-empty = "trashy list | fzf --multi | awk '{$1=$1;print}' | rev | cut -d ' ' -f1 | rev | xargs trashy empty --match=exact --force";
  };
}
