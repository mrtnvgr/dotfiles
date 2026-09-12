{ lib, config, user, ... }: let
  cfg = config.modules.desktop;
in {
  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = { config, ... }: {
      home.sessionVariables.BROWSER = "firefox";

      programs.firefox = {
        enable = true;

        # Needed because `home.stateVersion` is less than "26.05".
        configPath = "${config.xdg.configHome}/mozilla/firefox";

        profiles."default".settings = {
          "browser.newtabpage.enabled" = false;
          "browser.tabs.closeWindowWithLastTab" = false;

          # Restore tabs
          "browser.startup.page" = 3;

          # Download files directly to home directory
          "browser.download.folderList" = 0;
        };
      };
    };
  };
}
