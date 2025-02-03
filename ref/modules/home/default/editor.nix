{ pkgs, ... }:
let
  spell = {
    url = "http://ftp.vim.org/vim/runtime/spell/";
    en = {
      url = spell.url + "en.";
      utf-8 = {
        url = spell.en.url + "utf-8";
        spl = builtins.fetchurl { url = spell.en.utf-8.url + ".spl"; sha256 = "0w1h9lw2c52is553r8yh5qzyc9dbbraa57w9q0r9v8xn974vvjpy"; };
        sug = builtins.fetchurl { url = spell.en.utf-8.url + ".sug"; sha256 = "1v1jr4rsjaxaq8bmvi92c93p4b14x2y1z95zl7bjybaqcmhmwvjv"; };
      };
    };
  };
in
{
  programs.vim = {
    enable = true;
    defaultEditor = true;

    settings = {
      background = "dark"; # Dark background
      mouse = "n"; # Stop using the mouse in my editor
      # Tab stuff
      expandtab = true;
      tabstop = 2;
      number = true; # Line numbers
      ignorecase = true; # Searching for chars
    };

    extraConfig = ''
      " Show whitespace in files
      set list
      
      " Keep indents
      set smartindent
      
      " Split window stuff
      nnoremap <C-H> <C-W><C-H>
      nnoremap <C-J> <C-W><C-J>
      nnoremap <C-K> <C-W><C-K>
      nnoremap <C-L> <C-W><C-L>
      cnoremap term bel term
      
      " Don't cut off words
      set linebreak
      
      " Spellchecker
      set spellfile=~/.vim/spell/en.utf-8.add
      " Spellchecker on text files
      au BufNewFile,BufRead,BufReadPost *.md,*.MD,*.txt,*.TXT set spell spelllang=en_us

      " Printer
      set printdevice=Brother_MFC_J6935DW
    '';

    plugins = with pkgs.vimPlugins; [
      vim-lsp
    ];
  };

  # Spellcheckers
  home.file = {
    ".vim/spell/en.utf-8.spl".source = spell.en.utf-8.spl;
    ".vim/spell/en.utf-8.sug".source = spell.en.utf-8.sug;
  };

  # For the fun of just using ed (but a more sane version with line awareness n' stuff)
  home.packages = [
    (
      pkgs.writeShellScriptBin "ed" ''
        ${pkgs.rlwrap}/bin/rlwrap ${pkgs.ed}/bin/ed --prompt='~'
      ''
    )
  ];
}
