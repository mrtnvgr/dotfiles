{ inputs, pkgs, config, lib, user, ... }: let
  # bandit = inputs.bandithedoge-pkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  # dsp56300 = bandit.dsp56300.override {
  #   # enable88emu = true;
  #
  #   enableJE8086 = false;
  #   enableNodalRed2x = false;
  #   enableOsTIrus = false;
  #   enableOsirus = false;
  #   enableVavra = false;
  #   enableXenia = false;
  # };

  plugins = with pkgs; [
    # auburn-sounds-inner-pitch
    # drumlabooh
    # dsp56300
    pitchnet
    # bandit.prisma
    tone3000
    auburn-sounds-inner-pitch
    auburn-sounds-graillon
    vital
  ];

  # NOTE: rom location
  # .local/share/The Usual Suspects/JE8086/roms (either single 512k bin or multiple mid)

  cfg = config.modules.desktop.audio.plugins.native;
  isAnyDawInstalled = config._internals.isAnyDawInstalled;

  mkAudioPluginsPaths = format: (lib.concatStringsSep ":" [
    "/home/${user}/.${format}"
    "/etc/profiles/per-user/${user}/lib/${format}"
    "/home/${user}/.nix-profile/lib/${format}"
    "/run/current-system/sw/lib/${format}"
  ]) + ":";
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

    environment.sessionVariables = {
      VST3_PATH = mkAudioPluginsPaths "vst3";
      VST_PATH = mkAudioPluginsPaths "vst";
      CLAP_PATH = mkAudioPluginsPaths "clap";
      LV2_PATH = mkAudioPluginsPaths "lv2";
      LADSPA_PATH = mkAudioPluginsPaths "ladspa";
    };
  };
}
