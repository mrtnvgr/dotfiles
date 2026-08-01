{ config, lib, user, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;

  # TODO: use oxidec
  colors = [
    "#f38ba8"
    "#a6e3a1"
    "#89b4fa"
    "#cba6f7"
    "#f5c2e7"
    "#94e2d5"
  ];
in {
  home-manager.users.${user} = lib.mkIf cfg.enable {
    programs.reanix.colors = colors;
  };
}
