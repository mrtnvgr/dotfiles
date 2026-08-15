{ lib, config, pkgs, ... }: let
  cfg = config.modules.desktop;

  lock = pkgs.writeScriptBin "lock" ''
    source ~/.cache/oxidec/templates/colors.sh
    ${pkgs.waylock}/bin/waylock          \
      -init-color      "0x''${OXI_VOID}"  \
      -input-color     "0x''${OXI_BG}"    \
      -input-alt-color "0x''${OXI_BG}"    \
      -fail-color      "0x''${OXI_BG}"    \
      "$@"
  '';
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ lock ];
    security.pam.services.waylock = {};

    # Disable automatic physlock runs
    # TODO: move to desktop/core
    # TODO: create automatic runs of waylock
    services.physlock.lockOn = {
      suspend = false;
      hibernate = false;
    };
  };
}
