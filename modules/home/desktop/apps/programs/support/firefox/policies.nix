{ config, ... }:

{
  AIControls = "blocked";
  AutofillAddressEnabled = false;
  AutofillCreditCardEnabled = false;
  DefaultDownloadDirectory = "${config.home.homeDirectory}/Downloads";
  DisableAppUpdate = true;
  DisableFeedbackCommands = true;
  DisableFirefoxStudies = true;
  DisablePocket = true;
  DisableTelemetry = true;
  DontCheckDefaultBrowser = true;
  OfferToSaveLogins = false;
}
