{ pkgs, lib, config, ... }: let
  cfg = config.modules.desktop.dev;
in {
  options.modules.desktop.dev.enable = lib.mkEnableOption "dev mode";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gcc
      gdb
      gnumake

      pkg-config
      cmake meson ninja

      android-tools
    ];
  };

  imports = [
    ./rust.nix
    ./python.nix
    ./platformio.nix
    ./c.nix
  ];
}
