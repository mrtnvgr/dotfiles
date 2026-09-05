{ user, ... }: {
  imports = [
    ./generic
    ./desktop
    ./laptop
    ./server
  ];

  home-manager.users.${user} = {
    imports = [ ./hm.nix ];
  };
}
