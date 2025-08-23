{ pkgs, lib, ... }:

{
  services.flatpak.packages = [
    (lib.fix (self: {
      appId = "moe.nyarchlinux.assistant";
      sha256 = "sha256-7Bidqdy8TGsgliYFRY7oQ4JLGnWSQGTuyktMhe+ndC4=";
      bundle = "${pkgs.fetchurl {
        url = "https://github.com/NyarchLinux/NyarchAssistant/releases/download/1.0.0/nyarchassistant.flatpak";
        inherit (self) sha256;
      }}";
    }))
  ];
  services.flatpak.overrides."moe.nyarchlinux.assistant" = {
    Context.filesystems = [ "home" ];
  };
}
