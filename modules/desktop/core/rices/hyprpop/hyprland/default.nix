{ pkgs, lib, config, user, ... }: let
  theme = config.modules.desktop.theme;
  inherit (theme.colorscheme) palette;
in {
  imports = [
    ./polkit.nix
    ./wallpaper.nix
  ];

  config = lib.mkIf (theme.rice == "hyprpop") {
    home-manager.users.${user} = { config, ... }: {
      home.sessionVariables.BROWSER = "firefox";
      wayland.windowManager.hyprland = {
        enable = true;

        # home.stateVersion <= 26.05
        configType = "lua";

        settings = with palette; {
          config.general = {
            "col.active_border" = "rgb(${blue})";
            "col.inactive_border" = "rgb(${gray2})";
          };

          config.misc."background_color" = "rgb(${background})";

          env = with builtins; attrValues (mapAttrs
            (name: value: { _args = [ name (toString value) ]; })
            config.home.sessionVariables
          );
        };

        extraConfig = lib.fileContents ./hyprland.lua;
      };

      xdg.portal = {
        extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
        configPackages = [ pkgs.hyprland ];
      };

      home.pointerCursor.hyprcursor.enable = true;
    };
  };
}
