{ config, lib, ... }: let
  cfg = config.modules.laptop;
in {
  config = lib.mkIf cfg.enable {
    # Keeps the foreground app prioritized and lowers CFS latency.
    services.system76-scheduler.enable = true;

    services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
        CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";

        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "balanced";

        # ideapad_laptop exposes only an on/off conservation mode
        # 1 = "Long Life", stop charging at ~60%.
        STOP_CHARGE_THRESH_BAT0 = 1;
      };
    };
  };
}
