{ config, pkgs, lib, user, ... }: let
  cfg = config.modules.generic.services.syncthing;

  folder = with lib.types; submodule {
    options = {
      id = lib.mkOption { type = singleLineStr; };

      path = lib.mkOption { type = singleLineStr; };

      devices = lib.mkOption {
        type = listOf singleLineStr;
        default = [];
      };
    };
  };

  start-syncthing = pkgs.writeScriptBin "start-syncthing" /* bash */ ''
    set -eo pipefail

    cleanup() {
      echo
      echo "Stopping syncthing services..."
      systemctl --user stop syncthing-init || true
      systemctl --user stop syncthing || true
    }
    trap cleanup EXIT INT TERM

    systemctl --user start syncthing-init
    xdg-open http://127.0.0.1:8384

    echo "Syncthing is running. Press Ctrl+C to stop."
    sleep infinity
  '';
in {
  options.modules.generic.services.syncthing = {
    enable = lib.mkEnableOption "Syncthing";
    service.enable = lib.mkEnableOption "Syncthing systemd service";

    devices = lib.mkOption {
      type = with lib.types; attrsOf singleLineStr;
      default = {};
    };

    folders = lib.mkOption {
      type = with lib.types; attrsOf folder;

      default = {};
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home-manager.users.${user} = {
        services.syncthing = {
          enable = true;

          settings = {
            gui.theme = "dark";
            options.urAccepted = -1;

            devices = lib.mapAttrs (_: id: { inherit id; }) cfg.devices;
            folders = lib.mapAttrs (label: folder: {
              inherit (folder) id path devices;
              inherit label;
            }) cfg.folders;
          };
        };
      };

      networking.firewall = {
        allowedTCPPorts = [ 22000 ];
        allowedUDPPorts = [ 21027 22000 ];
      };
    })

    (lib.mkIf (cfg.enable && !cfg.service.enable) {
      home-manager.users.${user} = {
        systemd.user.services.syncthing.Install.WantedBy = lib.mkForce [];
        systemd.user.services.syncthing-init.Install.WantedBy = lib.mkForce [];

        home.packages = [ start-syncthing ];
      };
    })
  ];
}
