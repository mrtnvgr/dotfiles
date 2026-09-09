{
  inputs,
  config,
  lib,
  user,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.desktop.audio.rt;
in
{
  options.modules.desktop.audio.rt = {
    enable = mkEnableOption "tweaks for real-time audio";
  };

  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  config = mkIf cfg.enable {
    # Provided by nix-gaming modules
    # services.pipewire.lowLatency.enable = true;
    # programs.steam.platformOptimizations.enable = true;

    # powerManagement.cpuFreqGovernor = "performance";
    boot.kernel.sysctl."vm.swappiness" = 10;

    boot.kernelParams = [ "threadirqs" ];

    security.pam.loginLimits = [
      {
        domain = "@audio";
        item = "memlock";
        type = "-";
        value = "unlimited";
      }

      {
        domain = "@audio";
        item = "rtprio";
        type = "-";
        value = "99";
      }

      {
        domain = "@audio";
        item = "nofile";
        type = "soft";
        value = "99999";
      }

      {
        domain = "@audio";
        item = "nofile";
        type = "hard";
        value = "99999";
      }

      # note: workaround for fufexan/nix-gaming#173
      {
        domain = user;
        item = "nice";
        type = "hard";
        value = "-20";
      }
    ];

    services.udev.extraRules = ''
      KERNEL=="rtc0", GROUP="audio"
      KERNEL=="hpet", GROUP="audio"
      DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
    '';
  };
}
