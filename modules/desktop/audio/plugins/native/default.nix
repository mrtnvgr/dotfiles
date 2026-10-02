{ inputs, pkgs, config, lib, user, ... }: let
  mrtnvgr-lib = inputs.mrtnvgr.lib { inherit pkgs; };

  bandit = inputs.bandithedoge-pkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  dsp56300 = bandit.dsp56300.override {
    # enable88emu = true;

    enableJE8086 = false;
    enableNodalRed2x = false;
    enableOsTIrus = false;
    enableOsirus = false;
    enableVavra = false;
    enableXenia = false;
  };

  plugins = with pkgs; [
    # auburn-sounds-inner-pitch
    # drumlabooh
    # dsp56300
    pitchnet
  ];

  # NOTE: rom location
  # .local/share/The Usual Suspects/JE8086/roms (either single 512k bin or multiple mid)

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
