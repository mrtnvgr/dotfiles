{ user, ... }: {
  home-manager.users.${user}.programs.nixvim = {
    colorschemes.catppuccin.settings.custom_highlights = /* lua */ ''
      function(colors)
        return {
          DiagnosticInfo = { fg = colors.blue },
          DiagnosticHint = { fg = colors.purple },
          DiagnosticWarn = { fg = colors.yellow },
          DiagnosticError = { fg = colors.red },

          ["@comment.todo"] = { link = "DiagnosticInfo" },
          ["@comment.note"] = { link = "DiagnosticInfo" },
          ["@comment.error"] = { link = "DiagnosticError" },
          ["@comment.warning"] = { link = "DiagnosticWarn" },
        }
      end
    '';
  };
}
