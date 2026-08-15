{ lib, config, user, ... }: let
  cfg = config.modules.desktop;
in {
  config = lib.mkIf cfg.enable {
    security.polkit.enable = true;

    home-manager.users.${user} = {
      services.hyprpolkitagent.enable = true;
    };
  };
}
