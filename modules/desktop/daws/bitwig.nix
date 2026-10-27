{ pkgs, lib, config, user, ... }: let
  cfg = config.modules.desktop.daws.bitwig;
  samples = config.modules.desktop.paths.samples;

  dbmPath = "Bitwig Studio/Extensions/DrivenByMoss.bwextension";
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

      home-manager.users.${user} = {
        home.file.${dbmPath}.source = pkgs.drivenbymoss;
      };
    })

    (lib.mkIf (builtins.isString samples) {
      home-manager.users.${user} = {
        home.link."Bitwig Studio/Library/Samples" = samples;
      };
    })
  ];
}
