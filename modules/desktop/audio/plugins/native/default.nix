{ inputs, pkgs, config, lib, user, ... }: let
  mrtnvgr-lib = inputs.mrtnvgr.lib { inherit pkgs; };

  plugins = with pkgs; [
    # auburn-sounds-inner-pitch
    # drumlabooh
  ];

  cfg = config.modules.desktop.audio.plugins.native;
  isAnyDawInstalled = config._internals.isAnyDawInstalled;
in
{
  imports = [
    ./plugdata.nix
  ];

  options.modules.desktop.audio.plugins.native = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = isAnyDawInstalled;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = plugins;

    environment.sessionVariables = let
      make = format: mrtnvgr-lib.mkAudioPluginsPaths user format;
    in {
      VST3_PATH = make "vst3";
      VST_PATH = make "vst";
      CLAP_PATH = make "clap";
      LV2_PATH = make "lv2";
      LADSPA_PATH = make "ladspa";
    };
  };
}
