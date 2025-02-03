{ config, lib, pkgs, inputs, ... }:
let
  instances = [
    { name = "TerraFirmaGreg"; }
    { name = "GregTech- New Horizons"; displayName = "GregTech: New Horizons"; }
    { name = "GregTech Community Pack Modern"; }
    { name = "Monifactory"; }
    { name = "SevTech- Ages"; displayName = "SevTech: Ages"; }
    { name = "Murdering the Environment"; }
  ];
in
{
  xdg.desktopEntries = builtins.listToAttrs (map
    (
      { name
      , dotFolder ? false
      , displayName ? name
      }:

      {
        inherit name;
        value = {
          exec = "${pkgs.prismlauncher}/bin/prismlauncher --launch \"${name}\"";
          icon = "${config.xdg.dataHome}/PrismLauncher/instances/${name}/" + (if dotFolder then "." else "") + "minecraft/icon.png";
          name = "${displayName}";
        };
      }
    )
    instances);
}
