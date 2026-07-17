{ pkgs, lib, config, user, ... }: let
  inherit (lib) mkIf;
  theme = config.modules.desktop.theme;
in {
  config = mkIf (theme.rice == "hyprpop") {
    home-manager.users.${user} = {
      wayland.windowManager.hyprland.extraConfig = /* lua */ ''
        hl.on("hyprland.start", function()
            hl.exec_cmd("${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &")
        end)
      '';
    };

    # TODO: migrate to hyprpolkit

    security.polkit.enable = true;
  };
}
