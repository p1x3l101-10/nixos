{ globals, pkgs, config, lib, ext, ... }:

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
        -o StrictHostKeyChecking=yes \
        -o UserKnownHostsFile=${toString (pkgs.writeTextFile {
          name = "known_hosts";
          text = lib.concatStringsSep "\n" config.networking.sshForwarding.trustedHostKeys;
        })} \
        -o ServerAliveInterval=60 \
        -o ExitOnForwardFailure=yes \
        -D ${builtins.toString config.programs.proxychains.proxies.sshVps.port} \
        ${config.networking.sshForwarding.proxyUser}@${globals.vps.get} \
        -p ${toString config.networking.sshForwarding.sshPort}
    '';
  };
  services.postfix.package = pkgs.postfix.overrideAttrs (oldAttrs: {
    src = null;
    srcs = [ oldAttrs.src ./support ];
    sourceRoot = "postfix-3.10.7";
    postInstall = oldAttrs.postInstall + ''
      # Add a proxy handler
      mv $out/libexec/postfix/smtp $out/libexec/postfix/smtp.old
      cp ../support/smtp.pl $out/libexec/postfix/smtp
      chmod +x $out/libexec/postfix/smtp
    '';
  });
}
