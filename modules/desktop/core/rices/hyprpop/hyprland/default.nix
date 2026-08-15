{ pkgs, lib, config, user, ... }: let
  theme = config.modules.desktop.theme;
in {
  imports = [
    ./polkit.nix
  ];

  config = lib.mkIf (theme.rice == "hyprpop") {
    home-manager.users.${user} = { config, ... }: {
      wayland.windowManager.hyprland = {
        enable = true;

        # home.stateVersion <= 26.05
        configType = "lua";

        settings = {
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

      oxidec.files.".config/hypr/hyprland-colors.lua".text = /* tera */ ''
        hl.config({
            ["general"] = {
                ["col.active_border"] = "rgb({{ accent | strip }})",
                ["col.inactive_border"] = "rgb({{ gray2 | strip }})"
            },
            ["misc"] = {
                ["background_color"] = "rgb({{ void | strip }})"
            }
        })
      '';

      oxidec.reloaders."hyprland.sh".text = /* sh */ ''
        #!/bin/sh
        hyprctl reload >/dev/null
      '';
    };
  };
}
