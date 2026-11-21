{ pkgs, lib, config, user, ... }: let
  cfg = config.modules.desktop.daws.bitwig;
  samples = config.modules.desktop.paths.samples;

  themedBitwig = cfg.package.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      if [ ! -f $out/bin/.bitwig-studio-wrapped ]; then
        echo "bitwig themer: expected nixpkgs Bitwig launcher not found" >&2
        exit 1
      fi

      substituteInPlace $out/bin/.bitwig-studio-wrapped \
        --replace-fail 'bwrap \' '${pkgs.bitwig-theme-bwrap}/bin/bwrap \'
    '';
  });

  bitwigPackage = if cfg.themer.enable then themedBitwig else cfg.package;

  dbmPath = "Bitwig Studio/Extensions/DrivenByMoss.bwextension";
in {
  options.modules.desktop.daws.bitwig = {
    enable = lib.mkEnableOption "Bitwig Studio";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.bitwig;
    };

    themer.enable = lib.mkEnableOption "Bitwig Theme Editor";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      _internals.isAnyDawInstalled = true;

      environment.systemPackages = [ bitwigPackage ]
        ++ lib.optional cfg.themer.enable pkgs.bitwig-theme-editor;

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
