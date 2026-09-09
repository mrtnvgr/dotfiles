{ lib, config, ... }: let
  domain = config.modules.server.web.domain;
  cfg = config.modules.server.web.cdn;
in {
  options.modules.server.web.cdn = {
    enable = lib.mkEnableOption "cdn service";

    cdnPath = lib.mkOption {
      type = lib.types.str;
      default = "/var/www/cdn";
    };
  };

  config = lib.mkIf config.modules.server.web.cdn.enable {
    services.nginx.virtualHosts."cdn.${domain}" = {
      root = cfg.cdnPath;

      enableACME = true;
      forceSSL = true;
    };

    system.activationScripts.cdn-directory = lib.stringAfter [ "var" ] ''
      mkdir -p ${cfg.cdnPath}
      chmod 755 ${cfg.cdnPath}
    '';

	services.fail2ban.jails.cdn-bruteforce.settings = {
	  enabled = true;
    logpath = "/var/log/nginx/access.log";
	  backend = "auto";
	};

	environment.etc."fail2ban/filter.d/cdn-bruteforce.local".text = ''
	  [Definition]
      failregex = No such file or directory.* client: <HOST>,
	'';
  };
}
