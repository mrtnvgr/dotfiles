{ config, user, lib, ... }: let
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf cfg.enable {
    # TODO: replace with a smaller plugin
    plugins.todo-comments.enable = true;

    colorschemes.catppuccin.settings.custom_highlights = /* lua */ ''
      function(colors)
        return {
          DiagnosticInfo = { fg = colors.blue },
          DiagnosticHint = { fg = colors.purple },
          DiagnosticWarn = { fg = colors.yellow },
          DiagnosticError = { fg = colors.red },

          TODO = { link = "DiagnosticInfo" },
        }
      end
    '';
  };
}
