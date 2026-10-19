{ user, ... }: {
  home-manager.users.${user}.programs.nixvim = {
    plugins.colorizer = {
      enable = true;
      settings.user_default_options.names = false;
    };
  };
}
