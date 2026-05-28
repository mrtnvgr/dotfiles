{ lib, config, user, ... }: let
  cfg = config.modules.desktop.dev.c;
in
{
  options.modules.desktop.dev.c = {
    enable = lib.mkEnableOption "C dev env";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.nixvim.plugins.lsp.servers = {
        clangd.enable = true;
      };
    };
  };
}
