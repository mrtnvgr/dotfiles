{ config, pkgs, lib, user, ... }: let
  cfg = config.modules.generic.services.docker;
in {
  options.modules.generic.services.docker = {
    enable = lib.mkEnableOption "Docker";

    arm.enable = lib.mkEnableOption "Docker ARM runtime";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      virtualisation.docker.enable = true;
      environment.systemPackages = [ pkgs.docker ];
      users.users.${user}.extraGroups = [ "docker" ];
    })

    (lib.mkIf cfg.arm.enable {
      environment.systemPackages = [ pkgs.qemu ];
      boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
    })
  ];
}
