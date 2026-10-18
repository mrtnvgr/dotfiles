{ config, lib, ... }: {
  config = lib.mkIf config.modules.desktop.enable {
    services.physlock = {
      enable = true;
      allowAnyUser = true;
    };
  };
}
