{ user, ... }: {
  home-manager.users.${user}.programs.nixvim = {
    plugins.lastplace.enable = true;
  };
}
