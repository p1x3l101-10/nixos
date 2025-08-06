{ ext, ... }:

{
  home.packages = with ext; (with inputs; [
    self.packages.${system}.musicPlayerPlus
  ]);
}
