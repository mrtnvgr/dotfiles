{ pkgs, lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.server.misc.torrserver;

  torrserver = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "torrserver";
    version = "134";

    src = pkgs.fetchurl {
      url = "https://github.com/YouROK/TorrServer/releases/download/MatriX.${finalAttrs.version}/TorrServer-linux-amd64";
      hash = "sha256-WDygG9aGnD20nGxtG0t+T2KEwbJ+fZ0uRaCndirrsXI=";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];

    phases = "installPhase";
    installPhase = ''
      runHook preInstall
      install -Dm755 $src $out/bin/torrserver
      runHook postInstall
    '';
  });

  webIsSupported = config.modules.server.web.enable;
  domain = config.modules.server.web.domain;

  hasUsers = cfg.users != {};

  flags = "--port ${toString cfg.port} --httpauth";
in {
  options.modules.server.misc.torrserver = {
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

      path = [ pkgs.ffmpeg-full ];

      after = [ "network.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        User = "torrserver";
        Group = "torrserver";
        Type = "simple";
        NonBlocking = true;
        WorkingDirectory = "/etc/torrserver";
        ExecStart = "${torrserver}/bin/torrserver ${flags}";
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

    networking.firewall.allowedTCPPorts = [ cfg.port ];
    networking.firewall.allowedUDPPorts = [ cfg.port ];

    services.nginx.virtualHosts."ts.${domain}" = mkIf (webIsSupported && cfg.exposeWeb) {
      locations = {
        "/".proxyPass = "http://127.0.0.1:${toString cfg.port}";
      };

      enableACME = true;
      forceSSL = true;
    };
  };
}
