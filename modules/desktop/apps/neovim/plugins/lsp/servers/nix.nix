{ lib, config, user, ... }: let
  desk = config.modules.desktop;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf desk.dev.enable {
    lsp.servers.nixd.enable = true;
  };
}
