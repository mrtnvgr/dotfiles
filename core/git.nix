{ pkgs, user, ... }: {
  home-manager.users.${user} = {
    home.packages = with pkgs; [ github-cli git-lfs git-crypt ];

    programs.git = {
      enable = true;
      settings.pull.rebase = true;
    };
  };
}
