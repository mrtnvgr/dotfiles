{ lib, config, ... }: {
  config = lib.mkIf config.modules.desktop.enable {
    # Enable experimental Wayland support for Chromium based apps
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
