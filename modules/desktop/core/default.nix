{ ... }: {
  imports = [
    ./boot

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
    ./cursors.nix
    ./torsocks.nix
    ./delta.nix

    ./oxidec.nix
    ./guiServers
    ./rices

    ./browser
  ];
}
