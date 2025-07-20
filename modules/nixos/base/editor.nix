{ pkgs, lib, ... }: # Lib not needed usually, but is very nice for fakeHash later

{
  programs.vim = {
    enable = true;
    defaultEditor = true;
    package = (pkgs.vim-full.override { }).customize {
      name = "vim-with-plugins";
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [
          vim-lsp # LSP
          # LSP for snippets in other languages
          vim-vsnip
          vim-vsnip-integ
          # Autocomplete
          asyncomplete-lsp-vim
          asyncomplete-file-vim
          vim-vinegar # Improve dir browser
        ];
        opt = [];
      };
      vimrcConfig.customRC = ''
        " Spellcheck and imperitive adding
        set spell spelllang=en_us
        set spellfile=~/.vim/spell/en_US.utf-8.add
      '';
    };
  };
}
