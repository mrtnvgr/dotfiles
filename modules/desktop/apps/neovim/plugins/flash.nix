{ config, user, lib, ... }: let
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf cfg.enable {
    plugins.flash.enable = true;

    keymaps = let
      mkJump = key: {
        inherit key;
        mode = [ "n" "x" "o" ];
        action.__raw = ''require("flash").jump'';
      };
    in [
      (mkJump "f")
      (mkJump "s")
    ];
  };
}
