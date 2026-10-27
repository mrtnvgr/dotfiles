{ config, lib, user, ... }: let
  cfg = config.modules.desktop.apps.neovim;
in {
  options.modules.desktop.apps.neovim = {
    enable = lib.mkEnableOption "neovim";
  };

  config = {
    home-manager.users.${user}.programs.nixvim = lib.mkIf cfg.enable {
      clipboard.register = "unnamedplus";
      clipboard.providers.wl-copy.enable = true;
    };
  };

  imports = [
    ./plugins
    ./theme
  ];
}
