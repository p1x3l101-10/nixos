{ pkgs, ... }:

{
  home.packages = with pkgs; [
    trashy
    fzf
  ];
  home.shellAliases = {
    rm = "trash put";
    rm-force = "/run/current-system/sw/bin/rm";
    rm-list = "trash list | fzf --multi | awk '{$1=$1;print}' | rev | cut -d ' ' -f1 | rev | xargs trashy restore --match=exact --force";
    rm-empty = "trash list | fzf --multi | awk '{$1=$1;print}' | rev | cut -d ' ' -f1 | rev | xargs trashy empty --match=exact --force";
  };
}
