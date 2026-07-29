{ pkgs, lib, config, user, ... }: let
  theme = config.modules.desktop.theme;
  haveWallpaper = !(isNull theme.wallpaper);
in {
  config = lib.mkIf (theme.rice == "hyprpop" && haveWallpaper) {
    home-manager.users.${user} = {
      wayland.windowManager.hyprland.extraConfig = /* lua */ ''
        hl.on("hyprland.start", function()
            hl.exec_cmd("${pkgs.swaybg}/bin/swaybg -i ${theme.wallpaper}")
        end)
      '';
    };
  };
}
