{ pkgs, lib, ... }:

{
  programs.feh = {
    enable = true;
    package = pkgs.feh.overrideAttrs (oldAttrs: {
      # Enable auto convert
      buildInputs = oldAttrs.buildInputs ++ (with pkgs; [ file ]);
      makeFlags = oldAttrs.makeFlags ++ [ "magic=1" ];
      postInstall = ''
        wrapProgram "$out/bin/feh" --prefix PATH : "${
          lib.makeBinPath (with pkgs; [
            libjpeg
            jpegexiforient
          ])
        }" \
                               --add-flags '--theme=feh --scale-down'
      '';
    });
  };
}

