{ colorschemes, pkgs, ... }: {
  modules.desktop = {
    enable = true;

    theme = {
      rice = "hyprpop";

      font = {
        name = "CaskaydiaMono Nerd Font Propo";
        package = pkgs.nerd-fonts.caskaydia-mono;
      };

      opacity = 0.8;

      colorscheme = colorschemes.catppuccin;
      wallpaper = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/73/wallhaven-73qz6y.png";
        hash = "sha256-CGZqwT976V8odi8lNThbSTIQFbhI9twC4h1jWPG06zM=";
      };
    };

    apps = {
      neovim.enable = true;
      browser.enable = true;
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
