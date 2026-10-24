{ lib, config, ... }: let
  cfg = config.modules.desktop.services.bluetooth;
in {
  options.modules.desktop.services.bluetooth.enable = lib.mkEnableOption "bluetooth support";

  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = false;
    services.blueman.enable = true;
  };
}
