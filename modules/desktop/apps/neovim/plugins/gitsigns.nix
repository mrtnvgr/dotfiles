{ user, ... }: {
  home-manager.users.${user}.programs.nixvim = {
    plugins.gitsigns.enable = true;

    # TODO: map git commands, e.g. "grh" (git reset hunk)
  };
}
