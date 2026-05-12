{ lib, config, user, pkgs, ... }: let
  theme = config.modules.desktop.theme;
  inherit (theme.colorscheme) palette;
in {
  home-manager.users.${user} = lib.mkIf (theme.rice == "hyprpop") {
    home.packages = [ pkgs.rofi ];

    home.file.".config/rofi/colors.rasi".text = /* css */ ''
      * {
        pink: #${palette.pink};
        mauve: #${palette.purple};
        red: #${palette.red};
        peach: #${palette.orange};
        yellow: #${palette.yellow};
        green: #${palette.green};
        teal: #${palette.teal};
        blue: #${palette.blue};
        text: #${palette.text};
        subtext1: #${palette.gray8};
        subtext0: #${palette.gray7};
        overlay2: #${palette.gray6};
        overlay1: #${palette.gray5};
        overlay0: #${palette.gray4};
        surface2: #${palette.gray3};
        surface1: #${palette.gray2};
        surface0: #${palette.gray};
        base: #${palette.background};
        crust: #${palette.void};
      }
    '';

    home.file.".config/rofi/config.rasi".source = ./config.rasi;
  };
}
