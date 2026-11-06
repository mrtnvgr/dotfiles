{ pkgs, config, lib, user, ... }: let
  picker = pkgs.writeShellScript "termfilechooser-yazi" /* sh */ ''
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

    ${lib.getExe pkgs.foot} \
      --app-id=termfilechooser \
      --window-size-pixels=900x600 \
      ${lib.getExe pkgs.yazi} "$@"

    if [ "$directory" = 1 ]; then
      if [ ! -s "$out" ] && [ -s "$out.1" ]; then
        cat "$out.1" > "$out"
      fi
      rm -f "$out.1"
    fi
  '';
in {
  config = lib.mkIf config.modules.desktop.enable {
    xdg.portal = {
      enable = true;

      extraPortals = [ pkgs.xdg-desktop-portal-termfilechooser ];

      config = {
        common.default = "*";
        common."org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
      };
    };

    xdg.mime.defaultApplications = {
      "application/pdf" = "firefox.desktop";
    };

    home-manager.users.${user} = {
      xdg.enable = true;

      xdg.userDirs = rec {
        enable = true;
        setSessionVariables = true;

        desktop = "/home/${user}";
        documents = "${desktop}/.local/documents";
      };

      xdg.portal = {
        enable = true;
        inherit (config.xdg.portal) extraPortals configPackages;
      };

      programs.yazi = {
        enable = true;
        shellWrapperName = "y";
      };

      xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
        [filechooser]
        cmd=${picker}
        default_dir=$HOME
        open_mode=suggested
        save_mode=last
      '';
    };

    programs.bash.shellAliases.o = "xdg-open";
  };
}
