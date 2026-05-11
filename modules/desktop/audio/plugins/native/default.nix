{ inputs, pkgs, config, lib, user, ... }: let
  mrtnvgr-lib = inputs.mrtnvgr.lib { inherit pkgs; };

  plugins = with pkgs; [
    neural-amp-modeler-lv2
    dragonfly-reverb
    airwin2rack
    # soundthread # TODO: waiting for package
    surge-xt-vst3
    vital # vitalium-vst3
    # decent-sampler # TODO: broken
    cardinal
    # odin2
    # shortcircuit-xt # TODO: useless for now :( too "beta"
    # lsp-plugins-vst3
    # TAL-plugins-vst2
    # fire
    # wolf-shaper
    # luftikus-vst2
    # LUFSMeter-vst2
    auburn-sounds-inner-pitch
    # wildergarden-maim
    # reevr
    # filtr
    # gate12
    # time12
    # qdelay
    # cstop
    # hamburger
    # drumlabooh
  ];

  cfg = config.modules.desktop.audio.plugins.native;
  isAnyDawInstalled = config._internals.isAnyDawInstalled;
in
{
  imports = [
    ./u-he.nix
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
