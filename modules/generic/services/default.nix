{ ... }: {
  imports = [
    ./sshd.nix
    ./docker.nix
    ./tor.nix
    ./syncthing.nix
  ];
}
