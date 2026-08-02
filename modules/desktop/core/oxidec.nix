{ inputs, lib, config, user, ... }: let
  cfg = config.modules.desktop;
  oxidec = inputs.oxidec.homeManagerModule;
in {
  home-manager.users.${user} = lib.mkIf cfg.enable {
    imports = [ oxidec ];
    oxidec.enable = true;

    oxidec.default.colorscheme = "c3";

    # catppuccin mocha
    oxidec.colorschemes.c3 = rec {
      background = "#1e1e2e";
      shadow = "#181825";
      void = "#11111b";

      gray  = "#313244";
      gray2 = "#45475a";
      gray3 = "#585b70";
      gray4 = "#6c7086";
      gray5 = "#7f849c";
      gray6 = "#9399b2";
      gray7 = "#a6adc8";
      gray8 = "#bac2de";

      text = "#cdd6f4";

      red    = "#f38ba8";
      green  = "#a6e3a1";
      yellow = "#f9e2af";
      blue   = "#89b4fa";
      purple = "#cba6f7";
      pink   = "#f5c2e7";
      teal   = "#94e2d5";
      orange = "#fab387";

      accent = blue;
    };

    # gruvbox
    oxidec.colorschemes.gruv = rec {
      background = "#282828";
      shadow = "#1d2021";
      void = "#1d2021";

      gray  = "#32302f";
      gray2 = "#3c3836";
      gray3 = "#504945";
      gray4 = "#665c54";
      gray5 = "#7c6f64";
      gray6 = "#928374";
      gray7 = "#a89984";
      gray8 = "#bdae93";

      text = "#ebdbb2";

      red    = "#ea6962";
      green  = "#a9b665";
      yellow = "#d8a657";
      blue   = "#7daea3";
      purple = "#d387ca";
      pink   = "#d3869b";
      teal   = "#89b482";
      orange = "#e78a4e";

      accent = yellow;
    };

    # rose-pine
    oxidec.colorschemes.rose = rec {
      background = "#191724";
      shadow = "#14131a";
      void = "#0f0e14";

      gray  = "#21202e";
      gray2 = "#3b384e";
      gray3 = "#524f67";
      gray4 = "#6e6a86";
      gray5 = "#7b7793";
      gray6 = "#908caa";
      gray7 = "#a6a2be";
      gray8 = "#bfbcd4";

      text = "#e0def4";

      red    = "#eb6f92";
      green  = "#31748f";
      yellow = "#f6c177";
      blue   = purple;
      purple = "#c4a7e7";
      pink   = purple;
      teal   = "#9ccfd8";
      orange = yellow;

      accent = purple;
    };

    # everforest
    oxidec.colorschemes.forest = rec {
      background = "#272e33";
      shadow = "#1b2124";
      void = "#13181b";

      gray  = "#374145";
      gray2 = "#445056";
      gray3 = "#515d64";
      gray4 = "#5e6b73";
      gray5 = "#7a8478";
      gray6 = "#859289";
      gray7 = "#9da9a0";
      gray8 = "#b6c0b8";

      text = "#d3c6aa";

      red    = "#e67e80";
      green  = "#a7c080";
      yellow = "#dbbc7f";
      blue   = "#7fbbb3";
      purple = pink;
      pink   = "#d699b6";
      teal   = "#83c092";
      orange = "#e69875";

      accent = green;
    };

    # everblush
    oxidec.colorschemes.forest2 = rec {
      background = "#141b1e";
      shadow = "#0e1417";
      void = "#0a1013";

      gray  = "#1b2225";
      gray2 = "#232a2d";
      gray3 = "#3b4245";
      gray4 = "#535a5d";
      gray5 = "#6b7275";
      gray6 = "#838a8d";
      gray7 = "#9ba2a5";
      gray8 = "#b3b9b8";

      text = "#dadada";

      red    = "#e57474";
      green  = "#8ccf7e";
      yellow = "#e5c76b";
      blue   = "#67b0e8";
      purple = "#c47fd5";
      pink   = purple;
      teal   = "#6cbfbf";
      orange = yellow;

      accent = green;
    };

    oxidec.templates."colors.sh".text = ''
      OXI_BG={{ background | strip }}
      OXI_VOID={{ void | strip }}
    '';

    oxidec.templates."terminals".text = /* sh */ ''
      #!/bin/sh
      printf '\033]10;{{ text }}\007'
      printf '\033]11;{{ background }}\007'
      printf '\033]12;{{ text }}\007'
      printf '\033]17;{{ text }}\007'
      printf '\033]19;{{ background }}\007'
      printf '\033]4;0;{{ background }}\007'
      printf '\033]4;1;{{ red }}\007'
      printf '\033]4;2;{{ green }}\007'
      printf '\033]4;3;{{ yellow }}\007'
      printf '\033]4;4;{{ blue }}\007'
      printf '\033]4;5;{{ purple }}\007'
      printf '\033]4;6;{{ teal }}\007'
      printf '\033]4;7;{{ text }}\007'
      printf '\033]4;8;{{ gray2 }}\007'
      printf '\033]4;9;{{ red }}\007'
      printf '\033]4;10;{{ green }}\007'
      printf '\033]4;11;{{ yellow }}\007'
      printf '\033]4;12;{{ blue }}\007'
      printf '\033]4;13;{{ purple }}\007'
      printf '\033]4;14;{{ teal }}\007'
      printf '\033]4;15;{{ text }}\007'
    '';
    oxidec.reloaders."terminals.sh".text = /* sh */ ''
      #!/bin/sh
      for term in /dev/pts/*; do
          [ -w "$term" ] && sh $HOME/.cache/oxidec/templates/terminals > "$term"
      done
    '';
  };
}
