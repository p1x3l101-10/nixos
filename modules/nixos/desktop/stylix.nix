{ pkgs, config, ext, ... }:

{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest.yaml";
    image = with config.lib.stylix.colors.withHashtag;
      pkgs.runCommand "cat.png" {} ''
        pastel=${pkgs.pastel}/bin/pastel
        SHADOWS=$($pastel darken 0.1 '${base05}' | $pastel format hex)
        TAIL=$($pastel lighten 0.1 '${base02}' | $pastel format hex)
        HIGHLIGHTS=$($pastel lighten 0.1 '${base05}' | $pastel format hex)

        ${pkgs.imagemagick}/bin/convert ${ext.assets.img."basecat.png"} \
	        -fill '${base00}' -opaque black \
	        -fill '${base05}' -opaque white \
	        -fill '${base08}' -opaque blue \
	        -fill $SHADOWS -opaque gray \
	        -fill '${base02}' -opaque orange \
	        -fill $TAIL -opaque green \
	        -fill $HIGHLIGHTS -opaque brown \
	        $out'';
    polarity = "dark";
    targets = {
    };
  };
}
