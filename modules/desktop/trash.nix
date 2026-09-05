{ config, lib, user, pkgs, ... }: let
  cfg = config.modules.desktop.trash;
in {
  options.modules.desktop.trash.enable = lib.mkEnableOption "safe rm replacement";

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.bash.shellAliases.rm = "${pkgs.rmw}/bin/rmw";

      home.file.".config/rmwrc".text = ''
        WASTE=$HOME/.local/share/Trash
        expire_age = 14
      '';
    };
  };
}
