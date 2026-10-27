{ config, user, pkgs, ... }: let
  cfg = config.modules.desktop;
in {
  home-manager.users.${user} = { lib, ... }: lib.mkIf cfg.enable {
    qt = {
      enable = true;

      platformTheme.name = "kde";
      style.name = "breeze";
    };

    home.packages = [ pkgs.kdePackages.breeze-icons ];

    home.activation.kdeBreezeDark = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
        --file "$HOME/.config/kdeglobals" \
        --group Icons --key Theme "breeze-dark"
    '';
  };
}
