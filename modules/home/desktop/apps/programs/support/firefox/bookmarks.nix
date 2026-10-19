{ osConfig, lib, ... }: # Needed so that the version of nix is tracked

let
  trimSemanticPatch = version: maxPlaces: builtins.addErrorContext "While trimming SemVer" (builtins.concatStringsSep "."
    (lib.lists.take
      maxPlaces
      (builtins.splitVersion version)
    )
  );
in {
  Toolbar = {
    College = {
      LMS = "https://occc.mrooms3.net";
      "Student Services" = "https://experience.elluciancloud.com/occc151";
      EMail = "https://outlook.cloud.microsoft/mail";
      Homepage = "https://occc.edu";
      Kahoot = "https://www.kahoot.it";
      "Interlibrary Loans" = "https://58718.account.worldcat.org/account/requests";
    };
    GSuite = {
      Calendar = "https://calendar.google.com";
      EMail = "https://mail.google.com";
    };
    Tools = {
      "Server Stuff" = {
        "Cloudflare Dashboard" = "https://dash.cloudflare.com";
      };
      "Job applications" = {
        Target = "https://target.wd5.myworkdayjobs.com/en-US/targetcareers/userHome";
      };
      "Graphing Calculator" = "https://desmos.com/calculator";
    };
    Manuals = {
      "NixOS Modules" = {
        NixOS = "file://${osConfig.system.build.manual.manualHTML}/share/doc/nixos/index.html";
        "nixos-cli" = "https://nix-community.github.io/nixos-cli/";
        "Home Manager" = "https://nix-community.github.io/home-manager/";
        Stylix = "https://nix-community.github.io/stylix/";
        Nixvim = "https://nix-community.github.io/nixvim/";
        Nixcord = "https://4evy.github.io/nixcord/";
        Nimi = "https://weyl-ai.github.io/nimi/index.html";
      };
      Nix = {
        Nix = "https://nix.dev/manual/nix/${trimSemanticPatch osConfig.nix.package.version 2}";
        "Nix.Dev" = "https://nix.dev/";
        "Nix Builtins and Nixpkgs Lib" = "https://teu5us.github.io/nix-lib.html";
        "Nixpkgs Manual" = "https://ryantm.github.io/nixpkgs";
      };
      "Nushell Documentation" = {
        "The Nushell Book" = "https://www.nushell.sh/book/";
        "Command Reference" = "https://www.nushell.sh/commands/";
        Cookbook = "https://www.nushell.sh/cookbook/";
        "Language Reference Guide" = "https://www.nushell.sh/lang-guide/";
      };
      "Hyprland Wiki" = "https://wiki.hypr.land";
    };
  };
}
