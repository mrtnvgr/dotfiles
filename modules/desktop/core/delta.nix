{ lib, config, user, ... }:
let
  cfg = config.modules.desktop;
in {
  home-manager.users.${user}.programs.delta = lib.mkIf cfg.enable {
    enable = true;
    enableGitIntegration = true;
  };
}
