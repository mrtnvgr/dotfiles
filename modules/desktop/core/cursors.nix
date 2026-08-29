{ config, pkgs, user, lib, ... }: let
  cfg = config.modules.desktop;

  name = "Maple";
  size = 28;
in {
  home-manager.users.${user}.home.pointerCursor = lib.mkIf cfg.enable {
    enable = true;

    package = pkgs.maplestory-cursor;
    inherit name size;

    gtk.enable = true;
    x11.enable = config.services.xserver.enable;
  };
}
