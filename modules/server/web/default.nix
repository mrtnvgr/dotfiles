{ lib, config, ... }: let
  cfg = config.modules.server.web;
in {
  options.modules.server.web = {
    enable = lib.mkEnableOption "web services";
    domain = lib.mkOption { type = lib.types.singleLineStr; };
    master = lib.mkOption { type = lib.types.singleLineStr; };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    security.acme = {
      acceptTerms = true;
      defaults.email = cfg.master;
    };

    services.nginx = {
      enable = true;

      recommendedBrotliSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };

    services.fail2ban.jails = {
      nginx-bad-request.settings = {
        backend = "auto";
        logpath = "/var/log/nginx/access.log";
        findtime = "10m";
        maxretry = 5;
        bantime = "1h";
      };

      nginx-botsearch.settings = {
        backend = "auto";
        logpath = "/var/log/nginx/access.log";
        findtime = "1h";
        maxretry = 3;
        bantime = "1d";
      };

      nginx-probe = {
        settings = {
          backend = "auto";
          logpath = "/var/log/nginx/access.log";
          findtime = "1h";
          maxretry = 3;
          bantime = "1d";
        };

        filter.Definition.failregex = ''
          ^<HOST> - \S+ \[\] "(?:GET|POST|HEAD|PUT|PATCH|DELETE) [^"]*(?:matrix/server|\.php|admin|wp-|\.env|\.git)[^"]*" (?:403|404)
        '';
      };

      nginx-ddos = {
        settings = {
          backend = "auto";
          logpath = "/var/log/nginx/access.log";
          findtime = "10m";
          maxretry = 10;
          bantime = "1d";
        };

        # 429 is what limit_req returns when limit_req_status is set;
        # 503 is the nginx default when it has not been changed.
        filter.Definition.failregex = ''
          ^<HOST> - \S+ \[\] "[^"]*" (?:429|503)
        '';
      };
    };
  };

  imports = [
    ./eggs.nix
    ./cdn.nix
  ];
}
