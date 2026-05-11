{ pkgs, user, ... }: {
  home-manager.users.${user} = {
    home.packages = with pkgs; [ github-cli git-lfs git-crypt ];
    programs.git = {
      enable = true;
      settings = {
        user.name = "mrtnvgr";
        user.email = "martynovegorOF@yandex.ru";

        pull.rebase = true;
      };

      signing = {
        signByDefault = true;

        format = "openpgp";
        key = "6FADDB43D5A5FE52683509435B3379E981EF48B1";
      };
    };
  };
}
