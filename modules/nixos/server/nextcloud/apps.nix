{ pkgs, config, ... }:

let
  inherit (pkgs) fetchNextcloudApp;
in {
  services.nextcloud.extraApps = {
    inherit (config.services.nextcloud.package.packages.apps) news contacts calendar tasks;
  };
}