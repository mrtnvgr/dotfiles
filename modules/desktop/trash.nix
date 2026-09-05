{ config, lib, pkgs, user, ... }: let
  cfg = config.modules.desktop.trash;
in {
  options.modules.desktop.trash.enable = lib.mkEnableOption "safe rm replacement";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.rip2 ];

    home-manager.users.${user} = {
      programs.bash.shellAliases.rm = "echo Please use 'rip' instead of rm. #";
    };
  };
}
