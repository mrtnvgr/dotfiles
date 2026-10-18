# Based on https://github.com/nix-community/srvos/blob/main/nixos/server/default.nix

{ lib, config, ... }: {
  config = lib.mkIf config.modules.server.enable {
    documentation.enable = false;
    documentation.info.enable = false;
    documentation.man.enable = false;
    documentation.nixos.enable = false;

    # No need for fonts on a server
    fonts.fontconfig.enable = false;

    # Anti-freeze
    systemd.enableEmergencyMode = false;
    systemd.settings.Manager.RuntimeWatchdogSec = "20s";
    systemd.settings.Manager.RebootWatchdogSec = "30s";

    # Disable sleep
    systemd.sleep.settings.Sleep = {
      AllowSuspend = "no";
      AllowHibernation = "no";
    };

    # use TCP BBR has significantly increased throughput and reduced latency for connections
    boot.kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
  };
}
