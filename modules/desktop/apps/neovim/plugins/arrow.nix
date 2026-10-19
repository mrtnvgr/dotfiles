{ user, ... }: {
  home-manager.users.${user}.programs.nixvim = {
    plugins.arrow.enable = true;
    # TODO: map to <Tab>
  };
}
