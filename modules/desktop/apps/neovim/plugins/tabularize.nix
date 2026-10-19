{ user, pkgs, ... }: {
  home-manager.users.${user}.programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.tabular ];
  };
}
