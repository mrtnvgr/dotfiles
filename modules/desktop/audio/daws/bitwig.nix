{ pkgs, lib, config, ... }: let
  cfg = config.modules.desktop.audio.daws.bitwig;
in {
  options.modules.desktop.audio.daws.bitwig = {
    enable = lib.mkEnableOption "Bitwig Studio";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.bitwig;
    };
  };

  config = lib.mkIf cfg.enable {
    _internals.isAnyDawInstalled = true;

    environment.systemPackages = [ cfg.package ];
  };
}
