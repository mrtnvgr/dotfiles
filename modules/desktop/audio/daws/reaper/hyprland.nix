{ lib, config, user, ... }: let
  reaper = config.modules.desktop.audio.daws.reaper;
in {
  home-manager.users.${user} = lib.mkIf reaper.enable {
    wayland.windowManager.hyprland.extraConfig = /* lua */ ''
      -- Tooltip fix
      -- https://github.com/hyprwm/Hyprland/issues/2278
      hl.window_rule({
          match = {
              class = "REAPER",
              title = "^$",
          },
          no_focus = true,
      })

      hl.window_rule({
          match = {
              class = "^REAPER$",
              title = "^Add FX to.+$",
          },
          float = true,
      })
    '';
  };
}
