{ pkgs, lib, config, ... }: let
  cfg = config.modules.desktop;

  flac2ogg = pkgs.writeScriptBin "flac2ogg" /* bash */ ''
    find . -name "*.flac" | parallel --bar "ffmpeg -i {} -c:a libopus -b:a 192k -map_metadata 0 {.}.opus && rm {}"
  '';
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xdg-utils

      xxd
      colordiff

      parallel

      android-file-transfer

      # my custom scripts
      flac2ogg
    ];
  };
}
