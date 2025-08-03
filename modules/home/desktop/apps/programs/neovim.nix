{ ... }:

{
  programs.nixvim = {
    enable = true;
    plugins = {
      neo-tree = {
        enable = true;
        filesystem = {
          filteredItems = {
            alwaysShow = [
              ".gitignore"
            ];
          };
        };
      };
      toggleterm = {
        enable = true;
      };
      gitsigns = {
        enable = true;
      };
      lspconfig = {
        enable = true;
      };
      cmp = {
        enable = true;
      };
      none-ls = {
        enable = true;
      };
      which-key = {
        enable = true;
      };
      mini = {
        enable = true;
        modules.icons = {
          style = "glyph";
        };
        mockDevIcons = true;
      };
    };
    lsp = {
      servers = {
        qmlls.enable = true;
        clangd.enable = true;
        nil_ls.enable = true;
        bashls.enable = true;
        fsautocomplete.enable = true;
      };
    };
    clipboard = {
      register = "unnamed";
      providers.wl-copy.enable = true;
    };
    opts = {
      number = true;
      shiftwidth = 2;
    };
    viAlias = true;
    vimAlias = true;
  };
  home.shellAliases.nv = "nvim";
}
