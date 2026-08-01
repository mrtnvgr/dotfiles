{ pkgs, ... }: {
  modules.desktop = {
    enable = true;

    theme = {
      rice = "hyprpop";

      font = {
        name = "CaskaydiaMono Nerd Font Propo";
        package = pkgs.nerd-fonts.caskaydia-mono;
      };
    };

    apps = {
      neovim.enable = true;
    };

    dev = {
      rust.enable = true;
      python.enable = true;
    };

    services = {
      bluetooth.enable = true;
    };
  };

  system.stateVersion = "23.05";
}
