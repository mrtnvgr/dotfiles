{ pkgs, lib, config, user, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.desktop.services.midi;
in {
  options.modules.desktop.services.midi.enable = mkEnableOption "midi support";
  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.timidity = {
        enable = true;
        extraConfig = ''
          soundfont ${pkgs.soundfont-arachno}/share/soundfonts/arachno.sf2

          # Enable all midi effects
          opt -Ewpvsetoz

          # Don't cut sustain to save CPU
          opt --no-fast-decay

          # Pan quickly, even if it sounds bad
          opt --fast-panning

          # Set chorus and reverb by song & soundfont
          opt EFreverb=1
          opt EFchorus=1

          # Never kill voices to save CPU
          opt -k0

          # Sustain fades after three seconds (3000ms)
          opt -m3000
        '';
      };
    };
  };
}
