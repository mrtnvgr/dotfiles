{ lib, config, user, ... }: let
  cfg = config.modules.laptop;

  # TODO: this solution is not universal, use screen ids? globs? ask user to provide names?
  laptop = "eDP-1";
  hdmi = "HDMI-A-1";

  reloadWaybar = "${config.systemd.package}/bin/systemctl --user restart waybar";

  mkProfile = name: outputs: {
    profile = {
      inherit name outputs;
      exec = [ reloadWaybar ];
    };
  };
in {
  home-manager.users.${user}.services.kanshi = lib.mkIf cfg.enable {
    enable = true;

    settings = [
      (mkProfile "docked" [
        { criteria = laptop; status = "disable"; }
        { criteria = hdmi; }
      ])

      (mkProfile "undocked" [
        { criteria = laptop; }
      ])
    ];
  };
}
