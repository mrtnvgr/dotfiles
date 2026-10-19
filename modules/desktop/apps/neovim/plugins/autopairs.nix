{ user, ... }: {
  home-manager.users.${user}.programs.nixvim = {
    plugins.nvim-autopairs.enable = true;
  };
}
