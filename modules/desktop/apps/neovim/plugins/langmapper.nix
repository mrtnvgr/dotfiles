{ user, ... }: {
  home-manager.users.${user}.programs.nixvim = {
    plugins.langmapper.enable = true;
  };
}
