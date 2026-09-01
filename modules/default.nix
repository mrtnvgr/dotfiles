{ user, ... }: {
  imports = [
    ./generic
    ./desktop
    ./server
  ];

  home-manager.users.${user} = {
    imports = [ ./hm.nix ];
  };
}
