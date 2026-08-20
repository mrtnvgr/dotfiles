{ config, lib, user, ... }: let
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf cfg.enable {
    plugins.treesitter = {
      enable = true;

      highlight.enable = true;
      indent.enable = true;
    };

    plugins.hmts.enable = true;

    plugins.ts-autotag.enable = true;
    plugins.ts-context-commentstring.enable = true;

    opts.foldmethod = "expr";
    opts.foldexpr = "v:lua.vim.treesitter.foldexpr()";
  };
}
