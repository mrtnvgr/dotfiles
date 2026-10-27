{ config, lib, user, ... }: let
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf cfg.enable {
    plugins.colorizer = {
      enable = true;
      settings.user_default_options.names = false;
    };
  };
}
