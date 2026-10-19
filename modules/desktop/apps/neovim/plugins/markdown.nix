{ user, pkgs, ... }: {
  home-manager.users.${user}.programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.markdown-nvim ];

    extraConfigLua = ''
      require("markdown").setup({
        mappings = {
          inline_surround_toggle = "<leader>m",
          inline_surround_toggle_line = "<leader>m",
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
