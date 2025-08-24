{ pkgs, inputs, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries = (with pkgs; [
    ])
      ++ (with pkgs.unityhub.fhsEnv.args; ((targetPkgs pkgs) ++ (multiPkgs pkgs)))
    ;
  };
  environment.systemPackages = with pkgs; [
    inputs.nix-autobahn.packages.x86_64-linux.nix-autobahn
    nix-index
  ];
}
