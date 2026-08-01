{ lib, config, user, pkgs, ... }: let
  theme = config.modules.desktop.theme;
in {
  home-manager.users.${user} = lib.mkIf (theme.rice == "hyprpop") {
    home.packages = [ pkgs.rofi ];

    oxidec.files.".config/rofi/colors.rasi".text = /* css */ ''
      * {
        pink: {{ pink }};
        mauve: {{ purple }};
        red: {{ red }};
        peach: {{ orange }};
        yellow: {{ yellow }};
        green: {{ green }};
        teal: {{ teal }};
        blue: {{ blue }};
        text: {{ text }};
        subtext1: {{ gray8 }};
        subtext0: {{ gray7 }};
        overlay2: {{ gray6 }};
        overlay1: {{ gray5 }};
        overlay0: {{ gray4 }};
        surface2: {{ gray3 }};
        surface1: {{ gray2 }};
        surface0: {{ gray }};
        base: {{ background }};
        crust: {{ shadow }};
      }
    '';

    home.file.".config/rofi/config.rasi".source = ./config.rasi;
  };
}
