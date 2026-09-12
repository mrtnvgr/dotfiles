{ pkgs, lib, config, user, ... }: let
  cfg = config.modules.desktop.daws.bitwig;
  samples = config.modules.desktop.audio.samples;

  drivenbymoss = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "drivenbymoss";
    version = "26.6.5";

    src = pkgs.fetchzip {
      url = "https://www.mossgrabers.de/Software/Bitwig/DrivenByMoss-${finalAttrs.version}-Bitwig.zip";
      hash = "sha256-DIFJBY9SX4QklKeSaazG/DJ+0psKKO+hfsO51+OQQC4=";
      stripRoot = false;
    };

    installPhase = ''
      cp DrivenByMoss.bwextension $out
    '';
  });
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
        home.file.${dbmPath}.source = drivenbymoss;
      };
    })

    (lib.mkIf (builtins.isString samples) {
      home-manager.users.${user} = {
        home.link."Bitwig Studio/Library/Samples" = samples;
      };
    })
  ];
}
