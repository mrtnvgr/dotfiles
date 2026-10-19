{ user, ... }: {
  home-manager.users.${user}.programs.nixvim = {
    plugins.oil.enable = true;
  };
}
