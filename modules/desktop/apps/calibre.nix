{ lib, config, pkgs, ... }: let
  cfg = config.modules.desktop.apps.calibre;
in {
  options.modules.desktop.apps.calibre.enable = lib.mkEnableOption "Calibre";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.calibre ];

    # Content server
    networking.firewall.allowedTCPPorts = [ 9090 ];

    # Smart local search visibility
    # https://github.com/koreader/koreader/wiki/calibre#24-ports-firewall
    networking.firewall.allowedUDPPorts = [ 54982 ];
  };
}
