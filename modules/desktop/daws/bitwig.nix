{ pkgs, lib, config, user, ... }: let
  cfg = config.modules.desktop.daws.bitwig;
  samples = config.modules.desktop.audio.samples;
in {
  options.modules.desktop.daws.bitwig = {
    enable = lib.mkEnableOption "Bitwig Studio";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.bitwig;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      _internals.isAnyDawInstalled = true;
      environment.systemPackages = [ cfg.package ];
    })

    (lib.mkIf (builtins.isString samples) {
      home-manager.users.${user} = {
        home.link."Bitwig Studio/Library/Samples" = samples;
      };
    })
  ];
}
