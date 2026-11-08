{ pkgs, config, lib, user, ... }: let
  cfg = config.modules.desktop;

  explorer = pkgs.writeShellScriptBin "explorer" /* sh */ ''
    exec ${lib.getExe pkgs.foot} ${lib.getExe pkgs.yazi} "$@"
  '';

  explorer-focused = pkgs.writeShellScriptBin "explorer-focused" /* sh */ ''
    exec ${lib.getExe pkgs.foot} \
      --app-id=explorer-focused  \
      --window-size-pixels=1600x900 \
      ${lib.getExe pkgs.yazi} "$@"
  '';

  picker = pkgs.writeShellScript "termfilechooser-explorer" /* sh */ ''
    multiple="$1"
    directory="$2"
    save="$3"
    path="$4"
    out="$5"
    debug="$6"

    set -e

    if [ "$debug" = 1 ]; then
      set -x
    fi

    if [ "$directory" = 1 ]; then
      set -- --chooser-file="$out" --cwd-file="$out.1" "$path"
    else
      set -- --chooser-file="$out" "$path"
    fi

    ${explorer}/bin/explorer-focused "$@"

    if [ "$directory" = 1 ]; then
      if [ ! -s "$out" ] && [ -s "$out.1" ]; then
        cat "$out.1" > "$out"
      fi
      rm -f "$out.1"
    fi
  '';
in {
  config = lib.mkIf cfg.enable {
    xdg.portal = {
      extraPortals = [ pkgs.xdg-desktop-portal-termfilechooser ];

      config = {
        common.default = "*";
        common."org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
      };
    };

    home-manager.users.${user} = {
      home.packages = [ explorer explorer-focused ];

      programs.yazi = {
        enable = true;
        shellWrapperName = "f";
      };

      xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
        [filechooser]
        cmd=${picker}
        default_dir=$HOME
        open_mode=suggested
        save_mode=last
      '';

      wayland.windowManager.hyprland.extraConfig = lib.mkAfter /* lua */ ''
        hl.bind("SUPER + E", hl.dsp.exec_cmd("explorer-focused"))

        -- Explorer (file manager and xdg-desktop-portal-termfilechooser picker)
        hl.window_rule({
            match = { class = "^explorer-focused$", },
            float = true,
            center = true,
            stay_focused = true,
            dim_around = true,
        })
      '';
    };
  };
}
