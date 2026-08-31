{ pkgs, lib, config, user, ... }: let
  cfg = config.modules.desktop;
in {
  imports = [
    ./polkit.nix
  ];

  config = lib.mkIf cfg.enable {
    environment.loginShellInit = /* bash */ ''
      # Launch WM/DE on TTY1, return to TTY when exiting
      [ "$(tty)" = "/dev/tty1" ] && start-hyprland >/dev/null
    '';

    xdg.portal = {
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
      configPackages = [ pkgs.hyprland ];
    };

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
        ${pkgs.hyprland}/bin/hyprctl reload >/dev/null
      '';
    };
  };
}
