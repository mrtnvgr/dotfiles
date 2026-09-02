{ config, lib, pkgs, user, ... }: let
  cfg = config.modules.desktop.trash;
in {
  options.modules.desktop.trash.enable = lib.mkEnableOption "rm with trash dir";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.trash-cli ];

    home-manager.users.${user} = {
      programs.bash.shellAliases.rm = "trash";
    };
  };
}
