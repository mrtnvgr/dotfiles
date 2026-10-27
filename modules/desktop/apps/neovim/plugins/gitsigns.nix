{ config, lib, user, ... }: let
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf cfg.enable {
    plugins.gitsigns.enable = true;

    # TODO: map git commands, e.g. "grh" (git reset hunk)
  };
}
