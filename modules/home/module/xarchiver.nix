{ config, pkgs, lib, ... }:
let
  cfg = config.programs.xarchiver;
  inherit (lib) mkOption types mkIf mkEnableOption;
  mkInt = default: mkOption { type = types.int; inherit default; };
  mkBool = default: mkOption { type = types.bool; inherit default; };
  mkStr = default: mkOption { type = types.str; inherit default; };
  mkPath = default: mkOption { type = types.path; inherit default; };
in
{
  options.programs.xarchiver = {
    enable = mkEnableOption "xarchiver";
    config = {
      preferred_format = mkInt 0;
      prefer_unzip = mkBool true;
      confirm_deletion = mkBool true;
      sort_filename_content = mkBool false;
      advanced_isearch = mkBool true;
      store_output = mkBool false;
      icon_size = mkInt 2;
      show_archive_comment = mkBool false;
      show_sidebar = mkBool true;
      show_location_bar = mkBool true;
      show_toolbar = mkBool true;
      preferred_custom_cmd = mkStr "";
      preferred_temp_dir = mkPath "/tmp";
      preferred_extract_dir = mkPath "/tmp";
      allow_sub_dir = mkInt 0;
      extended_dnd = mkInt 1;
      ensure_directory = mkBool true;
      overwrite = mkBool false;
      full_path = mkInt 2;
      touch = mkBool false;
      fresh = mkBool false;
      update = mkBool false;
      store_path = mkBool false;
      updadd = mkBool true;
      freshen = mkBool false;
      recurse = mkBool true;
      solid_archive = mkBool false;
      remove_files = mkBool false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.xarchiver ];

    xdg.configFile = {
      "xarchiver/xarchiverrc".source = (pkgs.formats.ini {}).generate "xarchiverrc" {
        xarchiver = cfg.config;
      };
    };
  };
}
