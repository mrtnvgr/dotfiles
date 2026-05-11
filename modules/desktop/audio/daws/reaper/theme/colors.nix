{ config, lib, user, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;
  inherit (config.modules.desktop.theme.colorscheme) palette;

  colors = with palette; [
    red
    green
    blue
    purple
    pink
    teal
  ];
in {
  home-manager.users.${user} = lib.mkIf cfg.enable {
    programs.reanix.colors = colors;
  };
}
