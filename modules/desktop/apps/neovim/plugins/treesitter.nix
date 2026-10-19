{ user, ... }: {
  home-manager.users.${user}.programs.nixvim = {
    plugins.treesitter = {
      enable = true;

      highlight.enable = true;
      indent.enable = true;
      folding.enable = true;
    };

    # TODO: broken? :(
    # plugins.hmts.enable = true;

    plugins.ts-autotag.enable = true;
    plugins.ts-context-commentstring.enable = true;
  };
}
