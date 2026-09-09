{ lib, config, user, ... }: {
  home-manager.users.${user}.programs.nixvim = lib.mkIf config.modules.desktop.apps.neovim.enable {
    plugins.blink-cmp = {
      enable = true;

      settings = {
        keymap.preset = "super-tab";
        completion.documentation.auto_show = true;
      };
    };

    plugins.blink-emoji.enable = true;
    plugins.blink-cmp-latex.enable = true;

    plugins.blink-cmp.settings.sources.providers = {
      emoji = {
        module = "blink-emoji";
        name = "Emoji";
        score_offset = 15;
        opts.insert = true;
      };

      latex-symbols = {
        module = "blink-cmp-latex";
        name = "Latex";
        opts.insert_command = false;
      };
    };

    plugins.blink-cmp.settings.sources.default = [
      "lsp"
      "path"
      "snippets" # TODO: use luasnip
      "buffer"
      "emoji"
      "latex-symbols"
    ];

    plugins.friendly-snippets.enable = true;
  };
}
