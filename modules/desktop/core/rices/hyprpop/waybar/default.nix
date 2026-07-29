{ inputs, lib, config, user, ... }:
let
  inherit (config.modules.desktop.theme.colorscheme) palette;
  inherit (lib) mkIf;

  rgb_background = inputs.nix-colors.lib.conversions.hexToRGBString ", " palette.background;
  theme = config.modules.desktop.theme;

  style = /* css */ ''
    * {
      border: none;
      border-radius: 0;
      box-shadow: none;
      min-height: 0;
      margin: 0;
      padding: 0;
      background-color: transparent;

      font-family: "${theme.font.name}", sans-serif;
      font-size: 13px;
    }

    window>box, tooltip {
      background-color: rgba(${rgb_background}, ${toString theme.opacity});
    }

    window>box {
      color: #${palette.text};
      border: 2px solid #${palette.blue};
      margin: 8px 10px 0;
    }

    #workspaces {
      margin-left: 8px;
    }

    #workspaces button {
      border: 2px solid transparent;
      padding: 2px 3px;
      margin: 4px 2px;

      /* match to hyprland animations */
      transition: all 600ms cubic-bezier(0, 0.75, 0.15, 1.0);
    }

    #workspaces button:nth-child(1) {
      color: #${palette.red};
    }
    #workspaces button.active:nth-child(1) {
      border-color: #${palette.red};
    }

    #workspaces button:nth-child(2) {
      color: #${palette.teal};
    }
    #workspaces button.active:nth-child(2) {
      border-color: #${palette.teal};
    }

    #workspaces button:nth-child(3) {
      color: #${palette.blue};
    }
    #workspaces button.active:nth-child(3) {
      border-color: #${palette.blue};
    }

    #workspaces button:nth-child(4) {
      color: #${palette.purple}
    }
    #workspaces button.active:nth-child(4) {
      border-color: #${palette.purple}
    }

    #workspaces button.empty {
      color: #${palette.text};
    }

    tooltip {
      border: 2px solid #${palette.blue}
    }

    tooltip label {
      color: #${palette.text};
    }

    #battery,
    #clock,
    #backlight,
    #wireplumber,
    #tray {
      border-radius: 2px;
      padding: 0px 8px;
      margin: 4px;

      padding-left: 8px;
      padding-right: 8px;

      font-weight: bold;
      transition: all ease-in 200ms;
    }

    #wireplumber {
      color: #${palette.red};
    }
    #wireplumber.muted {
      color: #${palette.text};
    }

    #backlight {
      color: #${palette.yellow};
    }

    #battery {
      color: #${palette.blue};
    }

    #clock {
      color: #${palette.purple};
    }

    @keyframes blink_red {
      to { background-color: #${palette.red}; }
    }

    .discharging.warning,
    .discharging.critical,
    .discharging.urgent {
      animation-name: blink_red;
      animation-duration: 1s;
      animation-timing-function: linear;
      animation-iteration-count: infinite;
      animation-direction: alternate;
    }
  '';

  settings = [{
    layer = "top";

    modules-left = [ "hyprland/workspaces" ];
    modules-center = [ ];
    modules-right = [ "tray" "wireplumber" "backlight" "battery" "clock" ];

    "hyprland/workspaces" = {
      persistent-workspaces."*" = 4;
    };

    tray = {
      icon-size = 12;
      spacing = 5;
    };

    wireplumber = {
      format = "{icon} {volume}%";
      format-muted = "󰝟 {volume}%";
      on-click = "amixer -q sset Master toggle";
      format-icons = [ "" "" "" ];
      max-volume = 300;
    };

    backlight = {
      format = "{icon} {percent}%";
      format-icons = [ "" "" ];
    };

    battery = {
      interval = 10;
      states.warning = 30;
      states.critical = 15;
      format = "󰂄 {capacity}%";
      format-discharging = "{icon} {capacity}%";
      format-icons = [ "󰂎" "󰁻" "󰁾" "󰂀" "󰁹" ];
    };

    clock = {
      interval = 1;
      format = " {:%H:%M}";
      format-alt = " {:%e %B %Y}";
      tooltip = false;
    };
  }];
in {
  config = mkIf (theme.rice == "hyprpop") {
    home-manager.users.${user} = {
      programs.waybar = {
        enable = true;
        inherit style settings;
      };
    };
  };
}
