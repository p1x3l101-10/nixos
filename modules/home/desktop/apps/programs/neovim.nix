{ pkgs, ... }:

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
    extraPlugins = with pkgs.vimPlugins; [
      heirline-nvim
    ];
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
      expandtab = true;
      cursorline = true;
      ignorecase = true;
      tabstop = 2;
      title = true;
      undofile = true;
      wrap = false;
      writebackup = false;
      smartcase = true;
    };
    globals.mapleader = " ";
    viAlias = true;
    vimAlias = true;
    keymaps = [
      {
        mode = "n";
        key = "<leader>ef";
        action = "<cmd>Neotree toggle<cr>";
        options.desc = "Toggle file explorer";
      }
      {
        mode = "n";
        key = "<leader>eb";
        action = "<cmd>Neotree toggle buffers<cr>";
        options.desc = "Toggle buffer explorer";
      }
      {
        mode = "n";
        key = "<leader>eo";
        options.desc = "Toggle file explorer focus";
        action.__raw = ''
          function()
            if vim.bo.filetype == "neo-tree" then
              vim.cmd.wincmd "p"
            else
              vim.cmd.Neotree "focus"
            end
          end
        '';
      }
      {
        mode = "n";
        key = "<Leader>tf";
        action = "<Cmd>ToggleTerm direction=float<CR>";
        options.desc = "Open floating terminal";
      }
      {
        mode = "n";
        key = "<Leader>tl";
        action = "<Cmd>TermExec direction=float cmd=\"exec lazygit\"<CR>";
        options.desc = "Open floating terminal";
      }
      {
        mode = "n";
        key = "<Leader>w";
        action = "<Cmd>write<CR>";
        options.desc = "Save";
      }
      {
        mode = "n";
        key = "<Leader>c";
        action = "<Cmd>bdelete<CR>";
        options.desc = "Close buffer";
      }
    ];
  };
  home.shellAliases.nv = "nvim";
}
