{ ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character = let
        symbol = "❯";
        vimcmd_symbol = "❮";
      in {
        format = "$symbol ";
        success_symbol = "[${symbol}](bold green)";
        error_symbol = "[${symbol}](bold red)";
        vimcmd_symbol = "[${vimcmd_symbol}](bold green)";
        vimcmd_replace_one_symbol = "[${vimcmd_symbol}](bold purple)";
        vimcmd_replace_symbol = "[${vimcmd_symbol}](bold purple";
        vimcmd_visual_symbol = "[${vimcmd_symbol}](bold yellow)";
      };
    };
  };
}
