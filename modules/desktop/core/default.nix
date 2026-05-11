{ ... }: {
  imports = [
    ./graphics.nix
    ./sound.nix
    ./multimedia.nix
    ./fonts.nix
    ./gtk.nix
    ./qt.nix
    ./packages.nix
    ./network.nix
    ./wallpaper.nix
    ./kvm.nix
    ./xdg.nix
    ./colors.nix
    ./cursors.nix
    ./torsocks.nix

    ./rices
    ./guiServers

    ./boot
  ];
}
