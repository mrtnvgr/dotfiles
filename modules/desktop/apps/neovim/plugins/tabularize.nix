{ config, lib, user, pkgs, ... }: let
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf cfg.enable {
    extraPlugins = [ pkgs.vimPlugins.tabular ];
  };
}
