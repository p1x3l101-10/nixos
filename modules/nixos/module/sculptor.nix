{ config, options, pkgs, lib, ... }:

let
  cfg = config.services.sculptor;
  stringOpt = default: lib.mkOption {
    type = lib.types.str;
    inherit default;
  };
in
{
  options.services.sculptor = with lib; {
    enable = mkEnableOption "The Sculptor";
    package = mkOption {
      type = types.package;
      description = "Package to use";
      default = pkgs.internal.sculptor;
    };
    openFirewall = mkEnableOption "opening firewall";
    config = {
      authProviders = mkOption {
        type = with types; listOf (submodule {
          options = {
            name = mkOption { type = types.str; };
            url = mkOption { type = types.str; };
          };
        });
        description = "Can't work without at least one provider!";
        default = [
          { name = "Mojang"; url = "https://sessionserver.mojang.com/session/minecraft/hasJoined"; }
        ];
      };
      listen = {
        address = stringOpt "0.0.0.0";
        port = mkOption {
          type = types.port;
          default = 6665;
        };
      };
      assetsUpdaterEnabled = mkOption {
        type = types.bool;
        default = true;
        description = "If false, Sculptor will still respond to assets. Sculptor will handle any installed assets.";
      };
      motd = {
        displayServerInfo = mkEnableOption "MOTD" // { default = true; };
        sInfoUptime = stringOpt "Uptime: ";
        sInfoAuthClients = stringOpt "Authenticated clients: ";
        sInfoDrawIndent = mkEnableOption "" // { default = true; };
        customText = mkOption {
          type = with types; listOf attrs;
          description = "Formatted JSON of text";
          default = [
            { text = "You are connected to "; }
            {
              color = "gold";
              text = ''The Sculptor
              '';
            }
            {
              text = ''Unofficial Backend V2 for Figura
                
              '';
            }
            {
              clickEvent = {
                action = "open_url";
                value = "https://github.com/shiroyashik/sculptor";
              };
              text = "Please ";
            }
            {
              clickEvent = {
                action = "open_url";
                value = "https://github.com/shiroyashik/sculptor";
              };
              color = "gold";
              text = "Star";
              underlined = true;
            }
            {
              clickEvent = {
                action = "open_url";
                value = "https://github.com/shiroyashik/sculptor";
              };
              text = " me on GitHub!";
            }
          ];
        };
      };
      limitations = {
        maxAvatarSize = mkOption {
          type = types.int;
          description = "Maximum size of each avitar that is uploaded (in KiB)";
          default = 100;
        };
        maxAvatars = mkOption {
          type = types.int;
          description = "Maximum amount of avitars that can be uploaded";
          default = 10;
          # It doesn't look like Figura has any actions implemented with this?
          ## P.S. And it doesn't look like the current API allows anything like that...
        };
      };
      advancedUsers = mkOption {
        type = types.attrs;
        default = { };
        description = "With advancedUsers you can set additional parameters";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];
    environment.etc."sculptor/Config.toml" = {
      mode = "0444";
      source = ((pkgs.formats.toml { }).generate "Config.toml" {
        # Stupid JSON processing
        listen = with cfg.config.listen; "${address}:${builtins.toString port}";
        inherit (cfg.config) assetsUpdaterEnabled limitations advancedUsers;
        motd = {
          inherit (cfg.config.motd) displayServerInfo sInfoUptime sInfoAuthClients sInfoDrawIndent;
          customText = ''
            ${builtins.toJSON cfg.config.motd.customText}
          '';
        };
      });
    };
    systemd.services.sculptor = {
      description = "The Sculptor";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      restartTriggers = [
        "/etc/sculptor/Config.toml"
      ];
      restartIfChanged = true;
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/sculptor";
        StateDirectory = "sculptor";
        LogsDirectory = "sculptor";
        ConfigurationDirectory = "sculptor";

        # Sandboxing
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictRealtime = true;
        RestrictNamespaces = true;
        MemoryDenyWriteExecute = true;
      };
    };
    networking.firewall.allowedUDPPorts = lib.optional cfg.openFirewall cfg.config.listen.port;
  };
}
