{ config, ... }:
{
  programs.bash = {
    enable = true;
    historyFile = "${config.xdg.stateHome}/bash/history";
    enableVteIntegration = true;
    enableCompletion = true;
  };

  programs.zoxide = {
    enable = true;
    options = [ "--cmd=cd" ];
  };
}
