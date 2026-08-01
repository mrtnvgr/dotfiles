{ lib, config, user, ... }: let
  theme = config.modules.desktop.theme;
in {
  home-manager.users.${user} = lib.mkIf (theme.rice == "hyprpop") {
    programs.foot.enable = true;

    oxidec.files.".config/foot/foot.ini".text = ''
      [main]
      font=${theme.font.name}:size=13
      pad=10x10
      term=xterm-256color

      [mouse]
      hide-when-typing=yes

      [colors-dark]
      alpha=${toString theme.opacity}
      background={{ background | strip }}
      foreground={{ text | strip }}
      cursor={{ background | strip }} {{ text | strip }}
      regular0={{ background | strip }}
      regular1={{ red | strip }}
      regular2={{ green | strip }}
      regular3={{ yellow | strip }}
      regular4={{ blue | strip }}
      regular5={{ purple | strip }}
      regular6={{ teal | strip }}
      regular7={{ text | strip }}
      bright0={{ gray2 | strip }}
      bright1={{ red | strip }}
      bright2={{ green | strip }}
      bright3={{ yellow | strip }}
      bright4={{ blue | strip }}
      bright5={{ purple | strip }}
      bright6={{ teal | strip }}
      bright7={{ text | strip }}
    '';
  };
}
