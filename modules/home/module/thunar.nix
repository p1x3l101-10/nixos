{ config, pkgs, lib, ... }:
let
  cfg = config.programs.thunar;
  inherit (lib) mkOption types mkIf mkEnableOption optionals;
  mkStrOption = description: mkOption { inherit description; type = types.str; };
  actionSubmodule = { ... }: {
    options = {
      icon = mkStrOption "";
      name = mkStrOption "";
      unique-id = mkStrOption "";
      command = mkStrOption "";
      description = mkStrOption "";
      patterns = mkStrOption "";
      startup-notify = mkOption {
        type = types.bool;
        default = true;
      };
      directories = mkEnableOption "";
    };
    config = {};
  };
  toXMLSyled = { name, stylesheet, input }: pkgs.stdenvNoCC.mkDerivation {
      inherit name;
      nativeBuildInputs = [ pkgs.libxslt ];
      builder = pkgs.writeText "builder.sh" ''
        source $stdenv/setup
        xsltproc '${stylesheet}' '${pkgs.writeText "${name}.raw.xml" (builtins.toXML input)}' > $out
      '';
    };
in
{
  options.programs.thunar = {
    enable = mkEnableOption "thunar";
    thumbnails = mkEnableOption "thumbnails for thunar";
    config = {
      actions = mkOption {
        description = "List of right click actions";
        type = with types; listOf (submodule actionSubmodule);
        default = [];
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.xfce.thunar ] ++ (optionals cfg.thumbnails [ pkgs.xfce.tumbler ]);

    xdg.configFile."Thunar/uca.xml".source = toXMLSyled {
      name = "uca.xml";
      input = cfg.config;
      stylesheet = ./support/thunar/stylesheet.xsl;
    };
  };
}
