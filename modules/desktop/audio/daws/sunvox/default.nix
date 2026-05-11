{ pkgs, lib, config, user, ... }: let
  desktopCfg = config.modules.desktop;
  cfg = desktopCfg.audio.daws.sunvox;

  # Zooming with touchpad works only on OpenGL version
  # TODO: remove the override on update, nightradio responded <3
  sunvox = pkgs.sunvox.overrideAttrs (_: {
    postInstall = ''
      cp $out/bin/sunvox_opengl $out/bin/sunvox
    '';
  });
in {
  options.modules.desktop.audio.daws.sunvox = {
    enable = lib.mkEnableOption "SunVox";
  };

  config = lib.mkIf cfg.enable {
    _internals.isAnyDawInstalled = true;

    environment.systemPackages = [ sunvox ];

    home-manager.users.${user} = { lib, ... }: {
      home.activation.sunvox = lib.hm.dag.entryAfter ["writeBoundary"] ''
        cp ${./sunvox_config.ini} $HOME/.config/SunVox/sunvox_config.ini
      '';
    };
  };
}
