{ pkgs, lib, config, user, ... }: let
  cfg = config.modules.desktop;
  inherit (cfg) theme;

  # TODO: enable systemd integration, remove manual launch from hyprland

  style = ''
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
      background-color: {{ background }}
    }

    window>box {
      color: {{ text }};
      border: 2px solid {{ accent }};
      margin: 8px 10px 0;
    }

    #workspaces {
      margin-left: 8px;
    }

    #workspaces button {
      border: 2px solid transparent;
      padding: 2px 3px;
      margin: 4px 2px;
    }

    #workspaces button:nth-child(1) {
      color: {{ red }};
    }
    #workspaces button.active:nth-child(1) {
      border-color: {{ red }};
    }

    #workspaces button:nth-child(2) {
      color: {{ teal }};
    }
    #workspaces button.active:nth-child(2) {
      border-color: {{ teal }};
    }

    #workspaces button:nth-child(3) {
      color: {{ blue }};
    }
    #workspaces button.active:nth-child(3) {
      border-color: {{ blue }};
    }

    #workspaces button:nth-child(4) {
      color: {{ purple }};
    }
    #workspaces button.active:nth-child(4) {
      border-color: {{ purple }};
    }

    #workspaces button.empty {
      color: {{ text }};
    }

    tooltip {
      border: 2px solid {{ blue }};
    }

    tooltip label {
      color: {{ text }};
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
    }

    #wireplumber {
      color: {{ red }};
    }
    #wireplumber.muted {
      color: {{ text }};
    }

    #backlight {
      color: {{ yellow }};
    }

    #battery {
      color: {{ blue }};
    }

    #clock {
      color: {{ purple }};
    }

    @keyframes blink_red {
      to { background-color: {{ red }}; }
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
  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.waybar = {
        enable = true;
        inherit settings;
      };

      oxidec.files.".config/waybar/style.css".text = style;
      oxidec.reloaders."waybar.sh".text = "${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true";
    };
  };
}
