{ lib, ... }:

{
  # List of licences that I am ok with as a whole
  nixpkgs.config.allowlistedLicenses = with lib.licenses; [
    "unfreeRedistributable"
  ];
}