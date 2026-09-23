{ pkgs, lib, ... }:

{
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    settings = {
      plugin = {
        prepend_fetchers = [
          {
            url = "*";
            run = "git";
            group = "git";
          }
          {
            url = "*/";
            run = "git";
            group = "git";
          }
        ];
        prepend_preloaders = [
          {
            mime = "application/openxmlformats-officedocument.*";
            run = "office";
          }
          {
            mime = "application/oasis.opendocument.*";
            run = "office";
          }
          {
            mime = "application/ms-*";
            run = "office";
          }
          {
            mime = "application/msword";
            run = "office";
          }
          {
            mime = "*.docx";
            run = "office";
          }
        ];
        prepend_previewers = [
          {
            mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
            run = "ouch";
          }
          {
            mime = "application/openxmlformats-officedocument.*";
            run = "office";
          }
          {
            mime = "application/oasis.opendocument.*";
            run = "office";
          }
          {
            mime = "application/ms-*";
            run = "office";
          }
          {
            mime = "application/msword";
            run = "office";
          }
          {
            mime = "*.docx";
            run = "office";
          }
        ];
      };
      mgr.prepend_keymap = [
        {
          on = [ "<C-s>" ];
          run = "plugin diff";
          desc = "Diff the selected with the hovered file";
        }
        {
          on = [ "C" "C" ];
          run = "plugin ouch";
          desc = "Compress with ouch";
        }
        {
          on = [ "c" "m" ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        {
          on = [ "F" "G" ];
          run = "plugin yafg";
          desc = "Fuzzy search with ripgrep";
        }
        {
          on = [ "<C-d>" ];
          run = "plugin drag";
          desc = "Drag files";
        }
        {
          on = [ "<C-y>" ];
          run = "plugin wl-clipboard";
          desc = "Copy file to clipboard";
        }
        {
          on = [ "R" ];
          run = "plugin omni-trash";
          desc = "Open trash";
        }
        {
          on = [ "m" ];
          run = "plugin relative-motions";
          desc = "Trigger a new relative motion";
        }
      ];
      opener.extract = [
        {
          run = "ouch d -y %*";
          desc = "Extract here with ouch";
          for = "windows";
        }
        {
          run = "ouch d -y \"$@\"";
          desc = "Extract here with ouch";
          for = "unix";
        }
      ];
    };
    plugins = (lib.mapAttrs'
      (name: value: {
        name = builtins.replaceStrings [ ".yazi" ] [ "" ] pkgs.yaziPlugins."${name}".pname;
        value = {
          package = pkgs.yaziPlugins."${name}";
          setup = (value != {});
          settings = builtins.removeAttrs value [ "_forceSetup" ] ;
        };
      }) {
        relative-motions = { _forceSetup = true; };
        git = {
          order = 1500;
        };
        diff = { };
        ouch = { };
        chmod = { };
        mediainfo = { _forceSetup = true; };
        yafg = {
          toggle_mode_key = "alt-t";
          editor = "nvim";
          file_arg_format = "+{row} {file}";
        };
        drag = { };
        office = { };
        starship = {
          hide_flags = true;
          flags_after_prompt = true;
        };
        omni-trash = { };
        wl-clipboard = { };
      }
    );
  };
  # Plugin deps
  home.packages = with pkgs; [
    poppler-utils
  ];
}
