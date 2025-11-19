{ pkgs, ... }:

{
  home.packages = with pkgs; [
    trashy
    fzf
  ];
  home.shellAliases = {
    trash-list = "trash list | fzf --multi | awk '{$1=$1;print}' | rev | cut -d ' ' -f1 | rev | xargs trashy restore --match=exact --force";
    trash-empty = "trash list | fzf --multi | awk '{$1=$1;print}' | rev | cut -d ' ' -f1 | rev | xargs trashy empty --match=exact --force";
  };
}
