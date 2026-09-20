{ user, ... }: {
  imports = [
    # Base
    ../minix

    ./secrets/ssh.nix
  ];

  time.timeZone = "Europe/Moscow";

  home-manager.users.${user} = {
    programs.git.settings.user = {
      name = "mrtnvgr";
      email = "martynovegorOF@yandex.ru";
    };

    programs.git.signing = {
      signByDefault = true;

      format = "openpgp";
      key = "6FADDB43D5A5FE52683509435B3379E981EF48B1";
    };
  };
}
