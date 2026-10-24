{ pkgs, lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.server.services.torrserver;

  webIsSupported = config.modules.server.web.enable;
  domain = config.modules.server.web.domain;

  hasUsers = cfg.users != {};

  flags = "--port ${toString cfg.port} --httpauth";
in {
  options.modules.server.services.torrserver = {
    enable = mkEnableOption "torrserver";

    port = mkOption {
      type = types.port;
      default = 8090;
    };

    exposePort = mkOption {
      type = types.bool;
      default = cfg.enable;
      description = "expose torrserver's port in firewall";
    };

    exposeWeb = mkEnableOption "expose torrserver to domain";

    users = mkOption {
      type = types.attrsOf types.str;
      default = {};
    };
  };

  config = mkIf cfg.enable {
    systemd.services.torrserver = {
      enable = true;

      path = [ pkgs.ffmpeg-headless ];

      after = [ "network.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        User = "torrserver";
        Group = "torrserver";
        Type = "simple";
        NonBlocking = true;
        WorkingDirectory = "/etc/torrserver";
        ExecStart = "${lib.getExe pkgs.torrserver} ${flags}";
        ExecReload = "/bin/sh kill -HUP \${MAINPID}";
        ExecStop = "/bin/sh kill -INT \${MAINPID}";
        TimeoutSec = 30;
        Restart = "on-failure";
        RestartSec = "5s";
      };

      wantedBy = [ "multi-user.target" ];
    };

    users.groups.torrserver = {};
    users.users.torrserver = {
      group = "torrserver";
      isSystemUser = true;
    };

    systemd.tmpfiles.rules = [
      "d /etc/torrserver 0755 torrserver torrserver"
    ];

    environment.etc."torrserver/accs.db" = mkIf hasUsers {
      text = builtins.toJSON cfg.users;
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.exposePort [ cfg.port ];
    networking.firewall.allowedUDPPorts = mkIf cfg.exposePort [ cfg.port ];

    services.nginx.virtualHosts."ts.${domain}" = mkIf (webIsSupported && cfg.exposeWeb) {
      locations = {
        "/".proxyPass = "http://127.0.0.1:${toString cfg.port}";
      };

      enableACME = true;
      forceSSL = true;
    };
  };
}
