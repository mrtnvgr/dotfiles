{ pkgs, lib, config, user, ... }: let
  desktopCfg = config.modules.desktop;
  cfg = desktopCfg.audio.daws.sunvox;

  # TODO: use sunvox, not sunvox_opengl (after an update)
  # TODO: replace direct hyprctl calls with environment agnostic wrappers
  # (for other "rices" here)
  sunvox = pkgs.writeShellScriptBin "sunvox" ''
    hyprctl keyword input:repeat_delay 150
    ${pkgs.sunvox}/bin/sunvox_opengl "$@"
    hyprctl keyword input:repeat_delay 600
  '';
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
