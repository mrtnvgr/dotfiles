{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.desktop.services.bluetooth;
in {
  options.modules.desktop.services.bluetooth.enable = mkEnableOption "bluetooth support";
  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true;
    # TODO: applet
  };
}
