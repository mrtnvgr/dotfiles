{ lib, config, ... }:
let
  theme = config.modules.desktop.theme;
in {
  config = lib.mkIf (theme.rice == "hyprpop") {
    _internals = {
      guiServer = "wayland";
      DELauncher = "start-hyprland";
    };
  };

  imports = [
    ./hyprland
    ./waybar
    ./foot
    ./rofi
  ];
}
