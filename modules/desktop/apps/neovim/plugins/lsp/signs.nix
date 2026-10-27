{ lib, config, user, ... }: let
  desk = config.modules.desktop;
  enabled = desk.apps.neovim.enable && desk.dev.enable;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf enabled {
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
