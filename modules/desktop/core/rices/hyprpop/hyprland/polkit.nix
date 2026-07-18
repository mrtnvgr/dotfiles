{ lib, config, user, ... }: let
  theme = config.modules.desktop.theme;
in {
  config = lib.mkIf (theme.rice == "hyprpop") {
    security.polkit.enable = true;

    home-manager.users.${user} = {
      services.hyprpolkitagent.enable = true;
    };
  };
}
