{ config, lib, user, ... }: {
  config = lib.mkIf config.modules.desktop.enable {
    xdg.portal = {
      enable = true;
      config.common.default = "*";
    };

    home-manager.users.${user} = {
      xdg.enable = true;

      xdg.userDirs = rec {
        enable = true;
        setSessionVariables = true;

        desktop = "/home/${user}";
        documents = "${desktop}/.local/documents";
      };

      xdg.portal = {
        enable = true;
        inherit (config.xdg.portal) extraPortals configPackages;
      };
    };

    programs.bash.shellAliases.o = "xdg-open";
  };
}
