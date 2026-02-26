{ globals, pkgs, config, lib, ... }:

{
  programs.proxychains = {
    enable = true;
    proxies.sshVps = {
      type = "socks5";
      host = "127.0.0.1";
      port = 1081;
    };
  };
  systemd.services."ssh-proxy" = {
    wantedBy = [ "network.target" ];
    after = [ "network.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.openssh}/bin/ssh \
        -NTC \
        -vvv \
        -i /nix/host/keys/ssh-tunnel/id.key \
        -oStrictHostKeyChecking=yes \
        -o UserKnownHostsFile=${toString (pkgs.writeTextFile {
          name = "known_hosts";
          text = lib.concatStringsSep "\n" config.networking.sshForwarding.trustedHostKeys;
        })} \
        -o ServerAliveInterval=60 \
        -o ExitOnForwardFailure=yes \
        -D ${config.programs.proxychains.proxies.sshVps.port}
        ${config.networking.sshForwarding.proxyUser}@${globals.vps.get}
    '';
  };
  services.postfix.package = pkgs.symlinkJoin {
    name = "postfix-override-smtp";
    inherit (pkgs.postfix) version;
    paths = [
      pkgs.postfix
      (pkgs.stdenv.mkDerivation {
        name = "postfix-smtp-proxied";
        src = ./support;
        buildInputs = [
          pkgs.postfix
          pkgs.perl
          config.programs.proxychains.package
        ];
        installPhase = ''
          mkdir -p $out/libexec/postfix
          mv ./smtp.pl $out/libexec/postfix/smtp
          chmod 755 $out/libexec/postfix/smtp
          ln -s ${pkgs.postfix}/libexec/postfix/smtp $out/libexec/postfix/smtp.orig
        '';
      })
    ];
  };
}
