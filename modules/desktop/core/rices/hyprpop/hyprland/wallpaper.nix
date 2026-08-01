{ lib, config, user, ... }: let
  theme = config.modules.desktop.theme;
in {
  config = lib.mkIf (theme.rice == "hyprpop") {
    home-manager.users.${user} = {
      wayland.windowManager.hyprland.extraConfig = /* lua */ ''
        -- TODO: reload
        hl.on("hyprland.start", function()
            hl.exec_cmd("oxidec wallpaper reload")
        end)
      '';
    };
  };
}
