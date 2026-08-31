{ lib, ... }: {
  options.modules.desktop.enable = lib.mkEnableOption "desktop profile";

  imports = [
    ./core
    ./services
    ./apps
    ./daws
    ./dev
    ./games
    ./audio
    ./powersafe.nix
  ];
}
