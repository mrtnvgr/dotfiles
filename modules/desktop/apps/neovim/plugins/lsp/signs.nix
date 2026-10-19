{ lib, config, user, ... }: let
  isDev = config.modules.desktop.dev.enable;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf isDev {
    diagnostic.settings = {
      severity_sort = true;

      signs = {
        text."ERROR" = "😡";
        text."WARN" = "🤓";
        text."HINT" = "🤓";
        text."INFO" = "🤓";
      };

      # Update diagnostics in insert mode for instant feedback
      update_in_insert = true;
    };
  };
}
