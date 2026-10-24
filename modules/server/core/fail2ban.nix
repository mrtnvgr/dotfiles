{ lib, config, ... }: let
  cfg = config.modules.server;
in {
  config = lib.mkIf cfg.enable {
    services.fail2ban = {
      enable = true;

      bantime = "24h";

      bantime-increment = {
        enable = true;
        rndtime = "5m";
        maxtime = "1w";
        overalljails = true;
      };

      daemonSettings.Definition.dbpurgeage = "30d";

      jails = {
        DEFAULT.settings = {
          action = "%(action_)s[blocktype=DROP]";
          findtime = "4h";
        };

        recidive.settings = {
          bantime = "1w";
          findtime = "1d";
          maxretry = 5;
        };
      };
    };
  };
}
