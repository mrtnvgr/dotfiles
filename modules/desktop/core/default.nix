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

    ./colorscheme.nix
    ./guiServers
    ./rices

    ./browser
  ];
}
