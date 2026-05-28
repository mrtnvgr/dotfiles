{ pkgs, lib, config, user, ... }: let
  cfg = config.modules.desktop.dev;
in {
  options.modules.desktop.dev.enable = lib.mkEnableOption "dev mode";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gcc
      gnumake

      pkg-config
      cmake

      android-tools
    ];

    users.users.${user}.extraGroups = [ "adbusers" ];
  };

  imports = [
    ./rust.nix
    ./python.nix
    ./platformio.nix
    ./c.nix
  ];
}
