# Catppuccin has a nice and mature neovim plugin, let's use it as a base

{ config, user, lib, ... }: let
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user} = lib.mkIf cfg.enable {
    oxidec.files.".config/nvim/lua/oxidec.lua".text = /* tera */ ''
      require("catppuccin").setup({
          color_overrides = {
              -- skip if catppuccin for more color shades
              {% if not name | is: "c3" %}
              all = {
                  base = "{{ background }}",
                  blue = "{{ blue }}",
                  crust = "{{ void }}",
                  flamingo = "{{ text }}",
                  green = "{{ green }}",
                  lavender = "{{ blue }}",
                  mantle = "{{ shadow }}",
                  maroon = "{{ red }}",
                  mauve = "{{ purple }}",
                  overlay0 = "{{ gray4 }}",
                  overlay1 = "{{ gray5 }}",
                  overlay2 = "{{ gray6 }}",
                  peach = "{{ orange }}",
                  pink = "{{ pink }}",
                  red = "{{ red }}",
                  rosewater = "{{ text }}",
                  sapphire = "{{ blue }}",
                  sky = "{{ blue }}",
                  subtext0 = "{{ gray7 }}",
                  subtext1 = "{{ gray8 }}",
                  surface0 = "{{ gray }}",
                  surface1 = "{{ gray2 }}",
                  surface2 = "{{ gray3 }}",
                  teal = "{{ teal }}",
                  text = "{{ text }}",
                  yellow = "{{ yellow }}",
              },
              {% endif %}
          },
      })
    '';

    programs.nixvim.extraConfigLuaPre = ''
      pcall(require, "oxidec")
    '';

    programs.nixvim.extraConfigLuaPost = /* lua */ ''
      vim.loop.new_signal():start(vim.loop.constants.SIGUSR1, function()
        vim.schedule(function()
          package.loaded["oxidec"] = nil
          require("oxidec")
          vim.cmd.colorscheme("catppuccin")
        end)
      end)

      vim.schedule(function() vim.cmd.colorscheme("catppuccin") end)
    '';

    oxidec.reloaders."neovim.sh".text = "pkill -USR1 nvim || true";
  };
}
