{ ... }: {
  imports = [
    # Base
    ../minix

    ./secrets/ssh.nix
  ];

  time.timeZone = "Europe/Moscow";
}
