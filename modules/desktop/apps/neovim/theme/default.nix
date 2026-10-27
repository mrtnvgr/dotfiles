{ config, lib, user, ... }: let
  cfg = config.modules.desktop.apps.neovim;
in {
  imports = [
    ./overrides.nix
    ./diagnostics.nix
  ];

  home-manager.users.${user}.programs.nixvim = lib.mkIf cfg.enable {
    colorschemes.catppuccin.enable = true;
  };
}
