{ globals, pkgs, ... }:

{
  services.nginx.virtualHosts."${globals.server.dns.basename}" = globals.server.dns.required {
    addSSL = true;
    enableACME = true;
    locations."/".root = pkgs.stdenv.mkDerivation {
      name = "zola-build";
      src = ./webpage;
      nativeBuildInputs = with pkgs; [
        zola
      ];
      buildPhase = ''
        zola build
      '';
      installPhase = ''
        mv public $out
      '';
    };
  };
}
