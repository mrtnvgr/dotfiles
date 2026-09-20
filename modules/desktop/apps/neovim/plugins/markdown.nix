{ config, lib, user, pkgs, ... }: let
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf cfg.enable {
    extraPlugins = [ pkgs.vimPlugins.markdown-nvim ];

    extraConfigLua = ''
      require("markdown").setup({
        mappings = {
          inline_surround_toggle = "gs",
          inline_surround_toggle_line = "gss",
        },
        inline_surround = {
          strong = { key = "b", txt = "**" },
          emphasis = { key = "i", txt = "*" },
          code = { key = "c", txt = "`" },
        },
      })
    '';
  };
}
