{ globals, ... }:

{
  systemd.network.networks = {
    "10-wired" = {
      name = "enp2s0";
      DHCP = "yes";
      linkConfig.RequiredForOnline = "routable";
    };
    "10-wireless" = {
      name = "wlp0s20f3";
      DHCP = "yes";
      linkConfig.RequiredForOnline = "routable";
    };
  };
  networking.wireless.iwd = {
    enable = true;
    settings = {
      General = {
        EnableNetworkConfiguration = false; # NetworkD is handling that instead.
        AddressRandomization = "network";
        AddressRandomizationRange = "full";
        SystemdEncrypt = "iwd-secret";
        Country = "us";
      };
    };
  };
  systemd.services = let
    keydir = "${globals.dirs.keys}/iwd";
  in {
    # Dont start IWD until there is a valid credential
    iwd = {
      unitConfig.ConditionPathExists = "${keydir}/iwd-secret.cred";
      serviceConfig.LoadCredentialEncrypted = "iwd-secret:/${keydir}/iwd-secret.cred";
    };
    iwd-ensure-credentials = {
      description = "Generate IWD credentials";
      serviceConfig.Type = "oneshot";
      wantedBy = [ "iwd.service" ];
      before = [ "iwd.service" ];
      unitConfig.ConditionPathExists = [ "!${keydir}/iwd-secret.cred" ];
      # Generate a random encryption password for iwd to work with
      script = ''
        set -euxo pipefail
        mkdir -p "${keydir}"
        cd "${keydir}"
        umask 377
        cat /dev/urandom | tr -dc 'A-Za-z0-9!@#$%^&*_-' | head -c 64 | systemd-creds --tpm2-device=auto --name=iwd-secret encrypt - "${keydir}/iwd-secret.cred"
        chmod 0400 "${keydir}/iwd-secret.cred"
      '';
    };
  };
  environment.persistence."/nix/host/state/System".directories = [
    "/var/lib/iwd"
  ];
}
