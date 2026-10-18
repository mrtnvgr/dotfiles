{ config, lib, ... }: {
  config = lib.mkIf config.modules.desktop.enable {
    hardware.enableAllFirmware = true;
  };
}
