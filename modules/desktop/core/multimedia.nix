{ pkgs, lib, config, ... }: let
  grimmy = pkgs.writeScript "grimmy" ''
    ${pkgs.grim}/bin/grim "$@" - | wl-copy
    wl-paste > $HOME/$(date +%d.%m.%Y_%H:%M:%S).png
  '';

  slurp = "${pkgs.slurp}/bin/slurp";

  screenshot-select = pkgs.writeScriptBin "screenshot-select" ''${grimmy} -g "$(${slurp})"'';
  screenshot-full = pkgs.writeScriptBin "screenshot-full" grimmy;

  cfg = config.modules.desktop;
in {
  environment.systemPackages = lib.mkIf cfg.enable (with pkgs; [
    # Viewers
    feh mpv

    # Audio codecs
    flac lame

    # Video / image / audio modificators
    ffmpeg imagemagick sox rubberband

    # Screenshots
    screenshot-select screenshot-full

    # Video capturing
    obs-studio-plus
  ]);
}
