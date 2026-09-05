{ lib, config, user, pkgs, ... }: let
  cfg = config.modules.desktop;
in {
  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      gtk = {
        enable = true;

        theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome-themes-extra;
        };

        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };

        gtk4.theme = config.home-manager.users.${user}.gtk.theme;

        gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
        gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
      };

      dconf.settings = {
       "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      };

      xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

      xdg.configFile = let
        g = config.home-manager.users.${user}.gtk.theme.package;
      in {
        "gtk-4.0/assets".source = "${g}/share/themes/${g}/gtk-4.0/assets";
        "gtk-4.0/gtk.css".source = "${g}/share/themes/${g}/gtk-4.0/gtk.css";
        "gtk-4.0/gtk-dark.css".source = "${g}/share/themes/${g}/gtk-4.0/gtk-dark.css";
      };
    };

    # https://github.com/nix-community/home-manager/issues/3113
    programs.dconf.enable = true;
  };
}
