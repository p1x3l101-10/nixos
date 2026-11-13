# Needs preprocessing before use, split so that it can be used without a hard dep on nixos
# Also readability

{ nixManualVersion ? "latest"
, nixosManualUrl ? "https://nixos.org/manual/nixos/stable"
, firefoxLib
}:

let
  inherit (firefoxLib) mkOrdered transcribeBookmarks;
in transcribeBookmarks {
  Toolbar = [
    (mkOrdered "College" {
      LMS = "https://occc.mrooms3.net";
      "Student Services" = "https://experience.elluciancloud.com/occc151";
      EMail = "https://outlook.cloud.microsoft/mail";
      Homepage = "https://occc.edu";
      Kahoot = "https://www.kahoot.it";
      "Interlibrary Loans" = "https://58718.account.worldcat.org/account/requests";
      Info = {
        "Services for Students" = "https://catalog.occc.edu/content.php?catoid=7&navoid=288";
        "Recreation and Fitness" = "https://occc.edu/our-campus/fitness-center/index.html";
        "Student Life" = "https://occc.edu/student-life/index.html";
        Map = "https://map.concept3d.com/?id=468#!ct/6602,6630,7611?s/";
      };
    })
    (mkOrdered "GSuite" {
      Calendar = "https://calendar.google.com";
      EMail = "https://mail.google.com";
    })
    (mkOrdered "Tools" {
      "Server Stuff" = {
        "Cloudflare Dashboard" = "https://dash.cloudflare.com";
      };
      "Job applications" = {
        Target = "https://target.wd5.myworkdayjobs.com/en-US/targetcareers/userHome";
      };
      "Graphing Calculator" = "https://desmos.com/calculator";
    })
    (mkOrdered "Manuals" {
      "NixOS Modules" = {
        NixOS = nixosManualUrl;
        "nixos-cli" = "https://nix-community.github.io/nixos-cli/";
        "Home Manager" = "https://nix-community.github.io/home-manager/";
        Stylix = "https://nix-community.github.io/stylix/";
        Nixvim = "https://nix-community.github.io/nixvim/";
        Nixcord = "https://4evy.github.io/nixcord/";
        Nimi = "https://weyl-ai.github.io/nimi/index.html";
      };
      Nix = {
        Nix = "https://nix.dev/manual/nix/${nixManualVersion}";
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
    })
    (mkOrdered "Pinned" {
      Twitch = {
        "Rin Penrose" = "https://www.twitch.tv/rinpenrose";
        DougDoug = "https://www.twitch.tv/dougdoug";
      };
    })
  ];
}
