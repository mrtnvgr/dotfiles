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
    ./kvm.nix
    ./xdg.nix
    ./cursors.nix
    ./torsocks.nix
    ./delta.nix

    ./oxidec.nix

    ./wayland.nix
    ./lock.nix
    ./wm
    ./term.nix
    ./bar.nix
    ./launcher
    ./browser
  ];
}
