{ user, ... }: {
  home-manager.users.${user}.programs.nixvim = {
    plugins.lualine.enable = true;
  };
}
